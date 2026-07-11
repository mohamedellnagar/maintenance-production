# Budgeting Engine V1 — Implementation Plan

Built on top of the existing accounts / categories / transactions model without
changing it. No goals, forecasts, sync or AI in this phase.

## Model

- **Budget** — one per `(year, month, currency_code)`; status `draft | active |
  closed`.
- **BudgetItem** — `expense | saving | debtPayment | incomePlan`:
  - `expense` → an expense category; `incomePlan` → an income category;
  - `debtPayment` → a liability account; `saving` → free-form (custom name),
    no category/account in V1.
- **BudgetRollover** — a traceable record: `from_budget → to_budget`,
  `source_item → target_item`, `amount`. Never created automatically; only via
  the explicit close-month flow.

## Calculation rules (`BudgetCalculator`, pure)

- `expectedIncome` = Σ `incomePlan.assigned`.
- `actualIncome` = Σ non-deleted **income** transactions in the month (excludes
  transfers, adjustments, deleted).
- `totalAssigned` = Σ assigned of `expense + saving + debtPayment`
  (`incomePlan` excluded).
- `availableToAssign` = `expectedIncome + incomingRollover − assignedExpense −
  assignedSaving − assignedDebtPayment`. **Account balances never enter this.**
  A negative value warns but does not block saving.
- **Expense item**: `actualSpent` = Σ non-deleted expense transactions in the
  month whose category is the item's category **or a descendant** (see
  double-counting). `remaining = assigned + rolloverIn − actualSpent`;
  `overspent` when `actualSpent > assigned + rolloverIn`; usage % guarded
  against divide-by-zero; textual status (never color only).
- **incomePlan item**: `planned`, `actual` (income tx with that exact
  `category_id`), `variance = actual − planned`. Matched by id, never text.
- **debtPayment item**: `actualDebtPayment` counts only transactions that
  **reduce** the liability in the month — a transfer *into* the liability
  (`liabilityRepayment`) or income booked on it. Excludes card purchases, loan
  receipts (draw-downs), adjustments and deleted rows (`TransactionSemantic`).
- **saving item**: V1 shows the **planned** amount only — no reliable
  savings-account link exists yet, so no fabricated "actual". Documented.

### Month boundaries & hierarchy (documented decisions)

- Month range is the local half-open interval `[Y-M-01, Y-(M+1)-01)`, so
  leap-year February and December→January are correct and future-dated
  transactions inside the month are included.
- **Category hierarchy**: an expense item counts its category **and all
  descendants** (self+descendants). Double counting is prevented by forbidding
  two expense items in the same budget whose categories are equal or in an
  ancestor/descendant relationship. The seeded set is flat, so today this is
  effectively "category itself only", but it is correct if a hierarchy is added.

## Rollover

Expense items only, opt-in per item (`rollover_enabled`). Only a **positive**
remaining is carried, and only through the close-month flow. A deficit is shown
in the closed-month view but never auto-carried. Every carried amount has a
`budget_rollovers` row (source item → target item) created inside one atomic DB
transaction.

## Closed month

After close, budget items are read-only (edits blocked) until an explicit
**reopen** (with confirmation). Actual values are always derived live, so
editing an old transaction in a closed month **does** change that month's
actuals — surfaced as an in-app insight ("a closed month's results changed"),
never by freezing or deleting data.

## Database (schema v2, real migration)

New tables `budgets`, `budget_items`, `budget_rollovers` with foreign keys and:
- `UNIQUE(year, month, currency_code)` on budgets;
- `UNIQUE(budget_id, category_id)` and `UNIQUE(budget_id, account_id)` on items
  (SQLite treats NULLs as distinct) to block duplicate category/liability items;
- CHECKs: `item_type` enum, `assigned_amount_minor >= 0`, status enum.
`schemaVersion` → 2; `onUpgrade` creates the three tables; a migration test
upgrades a `user_version = 1` database and asserts the tables appear.

Cross-table rules (category type match, archived rejection, ancestor/descendant,
currency) are enforced in the repository inside the write transaction, with
database tests.

## Edge cases (tested)

Empty month, no expected income, no budget, zero-amount budget, overspend,
moving a transaction across months, category change, delete/restore, future
date in month, month boundaries, leap-year February, archiving after use,
editing an old transaction in a closed month, copying a previous (closed) month,
no previous month, reopen, deleting an item with a linked rollover.

## Screens

Bottom-nav **Budget** tab: month screen (nav prev/next, KPIs, sections for
Income Plan / Expense / Savings / Debt), item rows with progress + textual
status, create (empty / copy previous), add/edit item (type-specific), item
details (contributing transactions, rollover in/out), close-month flow.
Dashboard gets a reactive **Budget Summary** card. In-app insights only
(central thresholds).

## Tests

Unit (all calc rules + boundaries + leap year + hierarchy), database (migration,
one-per-month, CRUD, invalid/archived/duplicate rejection, copy, close
atomicity, rollover traceability, reopen, delete-with-rollover, FKs), integration
(transaction ↔ budget reactivity, cross-month move, repayment vs. charge,
dashboard), widget (empty state, create, copy, item validations, overspent,
close confirmation, read-only closed, dashboard card). The existing 88 tests
must keep passing.
