# Financial Goals & Savings Funds V1 — Implementation Plan

## 1. Goal vs. Savings Fund vs. Account

| Concept | What it is | Source of truth for | Affects balances / net worth? |
| --- | --- | --- | --- |
| **Account** | A real place money lives (cash, bank, wallet, card, loan). | The **actual money** the user has. | Yes (already). |
| **Financial Goal** | A *target*: name, type, target amount, optional date, priority, status. | The **target amount** and lifecycle. | **No.** |
| **Savings Fund** | A *virtual allocation bucket* attached 1:1 to a goal. | How much of the user's real money is **earmarked** for that goal. | **No** — it is a label on money, not a bank account. |

A Savings Fund is **not** a fake bank account. Allocating money to a goal does
not move or reserve it anywhere — the account balances are untouched. We track
five clearly separated numbers:

- **actual account balance** — from `BalanceCalculator` (unchanged).
- **allocated to goals** — sum of all goal fund balances.
- **unallocated available funds** — eligible liquid assets − allocated.
- **goal progress (funded)** — a single goal's fund balance.
- **target amount** — the goal's stored target.

## 2. Source of truth for the target amount

`financial_goals.target_amount_minor` (a fixed, user-entered value, `> 0`,
in the base currency). For **debtPayoff** the target is a **fixed snapshot**
saved at creation time; the linked liability's *current* balance is shown
separately (never overwriting the target). This keeps progress stable even as
the debt changes.

## 3. Contributions & withdrawals (the fund ledger)

The fund balance is **derived from a ledger** (`goal_fund_entries`), not stored
as the sole truth. `goal_funds.current_allocated_minor` is a **cached** value
kept in sync inside the same DB transaction as each ledger write; a
`recomputeFund` path (tested) rebuilds it from the ledger.

Entry types (all store a **positive** `amount_minor`; direction is explicit in
the type — no ambiguous signed value):

| Type | Effect on fund |
| --- | --- |
| `contribution` | + increases |
| `withdrawal` | − decreases |
| `transferIn` | + increases (from another goal) |
| `transferOut` | − decreases (to another goal) |
| `adjustment` | signed correction requiring a note (stored as a separate `adjustmentDirection`) |

Soft-deleted entries (`deleted_at`) never count toward the balance.

- **Contribution (manual allocation):** earmarks existing money. Creates a fund
  `contribution` entry **only** — no transaction, no account change.
- **Contribution (linked):** optionally references an existing transaction via
  `goal_transaction_allocations`. The link never re-books the transaction as an
  expense; the sum of a transaction's allocations must be `≤` its amount.
- **Withdrawal:** decreases the fund. Never creates income or an expense. If the
  user actually spent the money they record that as a separate real
  transaction; the withdrawal itself is not that expense. Bounded by the fund
  balance; optional note.

## 4. Link to budget & transactions

- Budget **saving items** may set `linked_goal_id`. The assigned saving stays a
  *plan*; the goal's **actual saving this month** is computed from
  `contribution` entries dated in the month (transfers between goals and
  withdrawals are shown separately, never folded into "contributed").
  `BudgetCalculator` expense/income math is **not** changed.
- Transactions link to goals only through `goal_transaction_allocations`
  (never by mutating the transaction). Eligible transaction types for linking:
  `transfer` (e.g. current→savings account) and `income`; documented in code.

## 5. Available-for-allocation rule (conservative, V1)

```
availableForGoalAllocation = eligibleLiquidAssets − totalAllocatedAcrossGoals
```

`eligibleLiquidAssets` = sum of the **positive** signed balances of
**non-archived** accounts of type **cash / bank / wallet**. Excluded by default:
`creditCard`, `loan`, other liabilities, `investment`, `asset` (property),
negative balances, and archived accounts.

- Allocation is a **virtual earmark**; it does not reserve money at the bank.
- V1 uses **explicit prevention**: a manual contribution that would push
  `totalAllocated` above `eligibleLiquidAssets` is rejected with a clear
  message (no `planning-only` over-allocation mode in V1).
- If balances later fall below the allocated total (e.g. the user spends),
  allocations are **not** auto-removed; instead an **Allocation Shortfall**
  warning is shown (`eligibleLiquidAssets < totalAllocated`). Tested.

## 6. Transfers between goals

`transferOut` from the source + `transferIn` to the destination inside **one DB
transaction**, cross-linked via `related_goal_id`. Source ≠ destination;
bounded by the source fund balance. Total allocated across goals is unchanged;
no account/net-worth effect.

## 7. Debt-payoff goals

- May link a `linked_liability_account_id` (must be a liability).
- Target = fixed amount snapshot at creation.
- Two separate indicators:
  1. **Saved for repayment** — the goal fund balance (money earmarked).
  2. **Actual debt reduced** — real liability **repayments** since the goal was
     created, computed from `TransactionSemantic.liabilityRepayment` toward the
     linked account (reuses the budgeting classifier). Earmarking is **not** a
     repayment.

## 8. Progress & projection (`GoalProgressCalculator`, pure, tested)

- **funded** = fund balance from the ledger.
- **fundingPercentage** = funded / target (clamped ≥ 0).
- **remaining** = `max(target − funded, 0)`.
- **overfunded** = `max(funded − target, 0)`.
- **requiredMonthlyContribution** (only if `targetDate` set) = `remaining`
  divided by **whole months remaining** (`max(1, monthsBetween(today,
  targetDate))`), rounded **up** in minor units; `0` once funded ≥ target.
- **projectedCompletionDate**: average of `contribution` entries over the last
  **3 months** (withdrawals and inter-goal transfers excluded). If the average
  is `0` → "cannot estimate". Otherwise `today + ceil(remaining / avg)` months.
- **on-track status**: `completed | noTargetDate | noContributionHistory |
  ahead | onTrack | behind` using central `GoalThresholds` (never in widgets).

All amounts are integer minor units; no `double` is ever stored.

## 9. Goal types & statuses

Types (affect icon + default copy only in V1; only `debtPayoff` changes
behaviour, via the optional liability link): `emergencyFund, home, car, travel,
education, wedding, retirement, debtPayoff, purchase, custom`.

Statuses: `draft, active, paused, completed, cancelled, archived`.
- `draft` excluded from the active summary.
- `active` accepts contributions.
- `paused` keeps its money but is not "needs funding now".
- `completed` when funded ≥ target or manually with confirmation.
- `cancelled` keeps the financial history (ledger preserved).
- `archived` for historical display.
- **No hard delete** if the goal has any fund ledger entry.

## 10. Database changes (schemaVersion 3 → 4)

New tables: `financial_goals`, `goal_funds` (UNIQUE goal_id),
`goal_fund_entries` (ledger, soft-delete), `goal_transaction_allocations`
(sum ≤ transaction amount). Plus `budget_items.linked_goal_id` (nullable FK).
CHECKs on enum columns and `amount_minor > 0` / `target_amount_minor > 0`.
Real `onUpgrade` for `from < 4`, with v3→v4 and v1→latest migration tests.

## 11. Edge cases (all tested)

No target date; target today; target in the past; 100% funded; overfunded;
withdraw full balance; withdraw > balance (rejected); contribute > available
(rejected); balances drop after allocation (shortfall); archived account;
linked transaction deleted/restored/edited; partial multi-goal transaction
allocation; allocation exceeding the transaction (rejected); full-balance
transfer; cancel goal with balance; delete goal with ledger (rejected);
debtPayoff with rising debt; completed goal then withdrawal; soft delete &
restore of an entry; language switch; February; month-end required-monthly;
projection with zero / with contributions+withdrawals; transfers not counted as
new contributions.

## 12. Test plan

- **Unit**: fund balance, contribution, withdrawal, transfer, total allocated,
  eligible funds, unallocated, shortfall, percentage, remaining, overfunded,
  required monthly, projected completion, on-track status, debt reduction,
  transaction-allocation limits, monthly contribution totals.
- **Database**: v3→v4 migration, clean latest, goal CRUD, status transitions,
  ledger CRUD, soft delete/restore, withdrawal limit, atomic transfer, duplicate
  fund protection, transaction allocation + over-allocation rejection, archived
  goal, cancel-with-balance, FKs, linked budget saving item, linked liability.
- **Integration**: balance change → available allocation; contribution →
  goal/dashboard/budget; withdrawal → summaries; transfer preserves total;
  transaction delete/restore vs linked contribution; budget saving actual; debt
  repayment → debt goal; reactive shortfall.
- **Widget**: empty state, create goal, emergency fund, debt payoff, initial
  contribution validation, details, add contribution, withdraw, transfer,
  overfunded, pause/resume, complete, cancel-with-balance, dashboard card,
  shortfall warning.

## 13. Recurring integration decision (V1)

To avoid unsafe scope creep, V1 does **not** add a new recurring "goal
contribution" type. Instead the recurring→goal link is left as a future
enhancement; the Goals docs recommend the user create a recurring transfer to a
savings account and link the posted transaction to the goal. No schema change to
recurring tables in this phase (documented in `recurring-model.md`).
