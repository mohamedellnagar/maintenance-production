# Budgeting Model (V1)

The monthly budget sits on top of accounts/categories/transactions without
changing them. All figures are derived live; nothing is duplicated from the
ledger. Every rule lives in `BudgetCalculator` and is unit-tested.

## Expected vs. actual income

- **Expected income** = Σ of `incomePlan` items' assigned amounts (a plan).
- **Actual income** = Σ of non-deleted `income` transactions dated inside the
  month. Transfers and adjustments never count.

```
incomePlan(Salary)=8,000 + incomePlan(Bonus)=1,000 → expected 9,000
income tx 8,000 (2026-07-05) → actual 8,000 → variance for Salary = 0
```

## Assigned vs. spent

- **Total assigned** = Σ assigned of `expense + saving + debtPayment`
  (`incomePlan` is a forecast, not an assignment).
- **Actual spent** (per expense item) = Σ non-deleted `expense` transactions in
  the month whose category is the item's category **or a descendant**.

```
Food assigned 300,000 (fils) ; expense txs 130,000 → remaining 170,000
```

## Available to assign

```
availableToAssign = expectedIncome + incomingRollover
                    − assignedExpense − assignedSaving − assignedDebtPayment
```

Account balances **never** enter this formula — it is plan-vs-plan only. A
negative value raises a warning insight but does not block saving (you may plan
against past savings).

## Overspending

```
overspent  ⇔  actualSpent > assigned + rolloverIn
usage%     = actualSpent / (assigned + rolloverIn)   (guarded at 0)
```

Status is textual (never color-only): *not started · on track · near limit
(≥80%) · overspent*.

## Planned savings

A `saving` item is a **plan**, not spending. V1 shows only the assigned amount;
there is no reliable link to a savings account yet, so no fabricated "actual" is
computed. (Documented limitation.)

## Debt payment

A `debtPayment` item targets a **liability account**. Its actual counts only
transactions that *reduce* the liability during the month:

- a **transfer into** the liability (a repayment), or
- **income booked on** the liability.

It excludes credit-card purchases (charges), loan receipts (draw-downs),
adjustments and deleted rows — determined via `TransactionSemantic`, not text.

```
transfer bank→card 200 → counts ; card purchase 150 → does NOT count
```

## Preventing double counting

- Two `expense` items for the same category are rejected (`UNIQUE`).
- Two `incomePlan` items for the same category are rejected (`UNIQUE`).
- Two `debtPayment` items for the same liability are rejected (`UNIQUE`).
- Because an expense item includes descendants, an item for a **parent** and one
  for its **child** in the same budget are rejected (repository hierarchy
  check). Decision: *self + descendants*, one item per category subtree.

## Rollover

Expense items only, opt-in per item. Only a **positive** remaining is carried,
and only through the close-month flow; a deficit is shown but never
auto-carried. Each carry is a `budget_rollovers` row (`from_budget`,
`to_budget`, `source_item`, `target_item`, `amount`) created in one atomic
transaction, and it increases the target item's `rolloverIn` next month.

## Closed month & editing old transactions

Closing snapshots the month's actual expense/income and marks it `closed`.
Budget items become read-only until an explicit **reopen** (with confirmation).
Actuals are always derived live, so **editing an old transaction in a closed
month does change that month's actuals** — this is surfaced as an insight ("a
closed month's results changed"), never by freezing or deleting data.

## Upcoming recurring (planned, not actual)

Recurring rules (see `recurring-model.md`) generate **planned occurrences**.
These are deliberately kept **out of** every budget number above — actual
spending, actual income, assigned, available-to-assign and remaining all ignore
unpaid occurrences, and the `BudgetCalculator` is not modified. Instead the
Budget screen and a budget item's details show them separately as **"Upcoming
recurring"**, matched to the month by due date and (for item details) to the
item's category or liability account. Only when an occurrence is **posted** does
it become a real transaction and flow into the budget's actuals like any other.

## Linked saving goals (planned vs. actual)

A **saving item** may set `linked_goal_id` (see `goals-model.md`). The assigned
amount stays a **plan**; the goal's **actual saving this month** is derived from
the fund's `contribution` entries dated in the month. Withdrawals and inter-goal
transfers are shown separately and never netted into "contributed", so a
transfer never reads as new saving. The item's details show *contributed this
month*, *withdrawn this month*, and *remaining planned contribution*. This is a
display-only overlay — `BudgetCalculator` and the expense/income actuals are
unchanged.

## Worked example

```
July budget (AED):
  incomePlan Salary  assigned 8,000     actual 8,000
  expense    Food    assigned   300     actual   130   remaining 170   on track
  expense    Fun     assigned   100     actual   150   OVERSPENT by 50
  saving     Emergency assigned 500     (plan only)
  debtPayment Card   assigned   200     actual   200 (a bank→card transfer)

Total assigned      = 300 + 100 + 500 + 200 = 1,100
Available to assign = 8,000 − 1,100 = 6,900
Overspent categories = 1 (Fun)
```
