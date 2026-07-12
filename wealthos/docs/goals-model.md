# Financial Goals & Savings Funds — Domain Model

WealthOS lets the user save toward goals **without creating fake balances or
distorting net worth**. The design separates three concepts:

| Concept | What it is | Affects real balances / net worth? |
| --- | --- | --- |
| **Account** | A real place money lives (cash, bank, card, loan). | Yes — the single source of truth for actual money. |
| **Financial Goal** | A *target*: name, type, target amount, optional date, priority, status. | **No.** |
| **Savings Fund** | A *virtual allocation bucket* attached 1:1 to a goal. | **No** — a label on money, not a bank account. |

Five clearly separated numbers:

- **actual account balance** — `BalanceCalculator` (unchanged).
- **allocated to goals** — sum of all goal fund balances.
- **unallocated available funds** — eligible liquid assets − allocated.
- **goal progress (funded)** — one goal's fund balance.
- **target amount** — the goal's stored target.

## Why allocation doesn't change net worth

Allocating money to a goal writes a **fund ledger entry only** — no transaction,
no account change. The money never moves; it is merely *earmarked*. So account
balances, assets, liabilities and net worth are all untouched. Only **posting a
real transaction** (which the user does separately) ever moves money.

## Target amount

`financial_goals.target_amount_minor` (fixed, `> 0`, base currency). For a
**debtPayoff** goal the target is a **fixed snapshot** at creation; the linked
liability's *current* balance is shown separately and never overwrites it.

## The fund ledger

The fund balance is **derived** from `goal_fund_entries` (the ledger).
`goal_funds.current_allocated_minor` is a **cached** copy kept in sync inside
every write transaction and rebuildable via `recomputeFund` (tested). Every
entry stores a **positive** amount; direction is explicit in the type:

| Entry type | Effect | Notes |
| --- | --- | --- |
| `contribution` | + | earmark existing money (no transaction) |
| `withdrawal` | − | un-earmark; never income/expense |
| `transferIn` | + | from another goal |
| `transferOut` | − | to another goal |
| `adjustment` | ± | requires a note + explicit `direction` |

Soft-deleted entries (`deleted_at`) contribute zero.

## Contributions & withdrawals

- **Manual contribution** earmarks money the user already has: a `contribution`
  entry, no transaction, no account change.
- **Linked contribution** may reference an existing transaction through
  `goal_transaction_allocations` — never re-booking it as an expense. The sum of
  a transaction's allocations must stay `≤` its amount (rejected otherwise).
- **Withdrawal** decreases the fund, bounded by the balance. It is **not** an
  expense. If the user actually spends the money, that is a separate real
  transaction; the withdrawal itself is not that expense.

## Transfers between goals

`transferOut` from the source + `transferIn` to the destination in **one DB
transaction**, cross-linked via `related_goal_id`. Source ≠ destination, bounded
by the source balance. Total allocated is unchanged; no account or net-worth
effect.

## Available for allocation & Allocation Shortfall

```
availableForGoalAllocation = eligibleLiquidAssets − totalAllocatedAcrossGoals
```

`eligibleLiquidAssets` = sum of **positive** balances of **non-archived** cash /
bank / wallet accounts. Credit cards, loans, other liabilities, investments,
fixed assets, negative balances and archived accounts are excluded.

- Allocation is a **virtual earmark** — it does not reserve money at the bank.
- V1 uses **explicit prevention**: a contribution that would push total
  allocation above eligible liquid is rejected.
- If balances later fall below the allocated total (e.g. the user spends),
  allocations are **not** removed; an **Allocation Shortfall** warning appears
  (`eligibleLiquidAssets < totalAllocated`). This is reactive and tested.

## Progress & projection (`GoalProgressCalculator`, pure, tested)

- **funded** = fund balance; **remaining** = `max(target − funded, 0)`;
  **overfunded** = `max(funded − target, 0)`.
- **requiredMonthly** (only with a target date) = `remaining` ÷ **whole months
  remaining** (`max(1, monthsBetween(today, targetDate))`), rounded up.
- **projectedCompletion** = `today + ceil(remaining / avg)` where `avg` is the
  average of `contribution` entries over the trailing 3 months (withdrawals and
  inter-goal transfers excluded). If `avg == 0` → **cannot estimate**.
- **on-track status**: `completed | noTargetDate | noContributionHistory | ahead
  | onTrack | behind` using central `GoalThresholds` (never in widgets).

All money is integer minor units; no `double` is stored.

## Debt-payoff goals

- May link a liability (`linked_liability_account_id`).
- Two separate indicators: **Saved for repayment** (the fund balance) and
  **Actual debt reduced** (real liability repayments since the goal was created,
  via `TransactionSemantic.liabilityRepayment`). Earmarking is **not** a
  repayment.

## Types & statuses

Types (icon + default copy only in V1; only `debtPayoff` changes behaviour):
`emergencyFund, home, car, travel, education, wedding, retirement, debtPayoff,
purchase, custom`.

Statuses: `draft, active, paused, completed, cancelled, archived`.
- `draft` excluded from the active summary; `active` accepts contributions;
  `paused` keeps its money but isn't "needs funding now"; `completed` when
  funded ≥ target or manually; `cancelled`/`archived` keep the ledger.
- **No hard delete** when a fund ledger exists.

## Completion & cancellation

- **Complete** happens on reaching the target or manually. Overfunding is
  allowed and shown as *overfunded*; the app suggests moving or withdrawing the
  surplus but never does it automatically.
- **Cancel with a balance** offers: transfer/keep the balance (archive) or
  un-allocate (withdraw) then cancel. The ledger is always preserved.

## Budget integration

A budget **saving item** may set `linked_goal_id`. The assigned saving stays a
*plan*; the goal's **contributed / withdrawn this month** are computed from the
ledger and shown in the item's details (withdrawals shown separately, never
netted into "contributed"). `BudgetCalculator` is not modified.

## Recurring integration (V1 decision)

V1 does **not** add a recurring "goal contribution" type. The recommended flow
is a recurring transfer into a savings account whose posted transaction the user
links to a goal. This keeps the engines decoupled and avoids unsafe scope creep.
