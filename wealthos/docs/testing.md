# Testing

Run everything:

```bash
flutter test
```

Tests are real behavioural checks, not smoke tests. Layout:

```
test/
  unit/        pure domain logic (no Flutter binding needed)
  database/    Drift against an in-memory SQLite database
  widget/      screen-level tests with an in-memory DB harness
```

## Unit tests

`test/unit/money_test.dart`
- addition, subtraction, unary minus, abs
- comparison operators + value equality
- currency-mismatch throwing on arithmetic and comparison
- parsing: decimals, integers, thousands separators, negatives, Arabic-Indic
  digits, too-many-fraction-digits rejection, empty/garbage rejection, tryParse
- formatting with grouping + symbol

`test/unit/financial_calculations_test.dart`
- transaction effects: income, expense, transfer (both sides), adjustment
  (signed), soft-deleted → no effect
- balance = opening + effects; destination receives transfer credit
- liability behaviour (expense increases owed, income reduces owed)
- net worth = assets − liabilities
- monthly income (in-month only) / monthly expense (excludes transfer +
  adjustment)

`test/unit/transaction_validator_test.dart`
- valid income/transfer pass
- zero/negative amount rejected
- missing account / missing destination / same-account transfer rejected
- adjustment allows negative but not zero; missing reason rejected

## Database tests

`test/database/database_test.dart` (in-memory `NativeDatabase.memory()`)
- migrations: schema version 1, all tables queryable
- category seeding is idempotent (16 rows after repeated seeds)
- account creation + retrieval; non-base-currency rejection; archive hides
- transaction creation
- **transfer atomicity**: a bad destination rolls back, nothing persists
- valid transfer moves balances correctly
- invalid transfer (same account) rejected before insert
- soft delete removes from queries but keeps the row with `deleted_at`

## Widget tests

`test/widget/` uses `TestHarness` (in-memory DB + MaterialApp + localizations).
- onboarding shows the language step and advances through all three steps
- empty dashboard renders the professional empty state
- add-account validation: empty name shows an error
- add-transaction validation: empty form flags amount + account

## Foundation-hardening tests

`test/unit/accounting_model_test.dart`
- `AccountBalance` signed vs. display vs. net-worth for assets and liabilities
- signed opening balance from user input (asset & liability)
- net worth with mixed assets/liabilities (spec example: −20,000)
- `AdjustmentCalculator` delta for assets and liabilities, and no-change → 0
- `TransactionSemantic` classification (charge, repayment, draw-down, …)

`test/database/hardening_test.dart` (real in-memory DB)
- liability scenarios: credit-card purchase, credit-card repayment, loan
  receipt, loan repayment, loan interest (balances + cash-flow effects)
- edit: amount recompute, transfer re-routed atomically, income→expense flip,
  missing-transaction rejection
- delete/restore: transfer effect removed then restored (same row), adjustment
  reversed, idempotent repeated delete
- integrity: archived account/destination/category rejection, wrong category
  type, category on a transfer, non-base currency, **foreign-key enforcement**
- summaries exclude soft-deleted rows

`test/integration/reactive_test.dart` (ProviderContainer + real DB)
- `allTransactionsProvider` reacts to create and delete
- `accountBalanceProvider` recomputes after a transaction

`test/widget/transaction_details_test.dart`
- details render (semantic label, account, status, note, effect)
- delete shows a confirmation dialog

## Budgeting tests (V1)

`test/unit/budget_calculator_test.dart`
- expected/actual income, total assigned, available-to-assign (no balance leak),
  incoming rollover; expense spending, remaining, overspend, usage %, near-limit
  and not-started status; category self+descendants; debt-payment (repayments
  only, excludes charge/draw-down/adjustment/deleted); month boundaries,
  leap-year February, December→January.

`test/database/budget_test.dart`
- **v1→v2 migration** creates the budget tables; one-budget-per-month; CRUD;
  invalid category type; archived category / non-liability rejection; duplicate
  and parent/child hierarchy rejection; copy previous month (items only, none
  when no previous); atomic close + traceable rollover; closed read-only;
  reopen; delete-with-linked-rollover rejection; foreign keys.

`test/integration/budget_reactive_test.dart`
- expense updates budget actual; edit amount; category change moves actual
  between items; delete then restore; repayment updates debt while a card charge
  does not — all through live providers.

`test/widget/budget_test.dart`
- empty budget state, add-item validation, overspent tile status, dashboard
  budget-card CTA, closed-month banner + reopen + read-only (no add FAB).

## Recurring tests (V1)

`test/unit/recurrence_calculator_test.dart`
- daily, every-N-days, weekly (multi-weekday + N-week interval), monthly by day
  (with day-31 clamping and Feb-29 leap clamping), monthly by ordinal (last
  Friday / first Monday, missing 5th skipped), yearly, **29 Feb** leap/non-leap
  fallback, `endDate` and `maxOccurrences` (counted from the first occurrence),
  and `nextOccurrence`.

`test/unit/recurring_status_test.dart`
- derived display status (scheduled/due/overdue/paid), paid-but-deleted reopens,
  snooze pushes the effective date, skipped/cancelled sticky; the insight
  builder for overdue / multiple-due-today / income-upcoming / auto-create-failed
  / archived-reference / many-unpaid.

`test/unit/recurring_validator_test.dart`
- name/amount/interval/reminder/max/end-before-start; type-specific
  account/category presence; weekly-needs-weekdays; monthly day-vs-ordinal
  exclusivity; yearly month/day; transfer/liability rules (no category, distinct
  accounts, destination required).

`test/database/recurring_test.dart`
- **v2→v3 migration** (tables + settings column); idempotent generation;
  unpaid ⇒ no transaction; posting an expense/liability-payment creates the
  correct transaction type; double-post rejection; delete-then-repost; skip;
  snooze; pause/resume; schedule-edit drops future unposted occurrences;
  posted-occurrence blocks rule deletion; archived-account and
  non-liability-destination rejection. (`test/database/budget_test.dart` also
  covers **v1→latest**.)

`test/integration/recurring_generation_test.dart`
- generation idempotency across runs; long-absence backfill surfaces overdue;
  auto-create posts only when enabled, exactly once, and never in the future.

`test/widget/recurring_test.dart`
- recurring empty state + add CTA; rule-form validation on empty submit;
  Upcoming Bills card hidden when there is no recurring data.

## Goals & savings funds tests (V1)

`test/unit/goal_allocation_calculator_test.dart`
- eligible liquid (positive cash/bank/wallet only; excludes liabilities,
  investments, property, archived, negatives); total allocated; available;
  shortfall detection and amount.

`test/unit/goal_progress_calculator_test.dart`
- funded/remaining/overfunded/ratio; required monthly (whole months, rounded up,
  clamped ≥ 1, month-boundary); projection (zero → cannot estimate; from the
  3-month average; transfers/withdrawals excluded); on-track statuses; actual
  debt reduced since goal creation.

`test/unit/goal_fund_test.dart`
- fund balance from the ledger (contributions/transfers/withdrawals/adjustments,
  soft-deleted → zero); the insight builder (shortfall, behind, near-completion,
  deadline-soon, stalled, completed + overfunded, emergency-fund low).

`test/database/goals_test.dart`
- **v3→v4 migration** (goal tables + `budget_items.linked_goal_id`); goal CRUD;
  fund created at zero; initial allocation; contribution (no transaction);
  contribute-over-available rejected; withdrawal limit; atomic transfer +
  preserved total; same-goal/over-balance transfer rejected; soft delete/restore
  rebuilds the cache; `recomputeFund`; status transitions; paused rejects
  contributions; delete-blocked-with-ledger; debt-only liability link + non-
  liability rejection; transaction over-allocation rejection.

`test/integration/goals_reactive_test.dart`
- contribution flows into the goal view + summary; spending after allocation
  raises the shortfall; inter-goal transfer preserves total allocated; a real
  repayment updates a debt goal's actual-debt-reduced — all through live
  providers.

`test/widget/goals_test.dart`
- goals empty state + add CTA; an active goal card renders; goal-form validation
  on empty submit; dashboard goals card hidden with no goals.

## Quality gate

```bash
dart format .
flutter analyze      # strict-casts / strict-inference / strict-raw-types
flutter test
```
