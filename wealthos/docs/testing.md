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

## Quality gate

```bash
dart format .
flutter analyze      # strict-casts / strict-inference / strict-raw-types
flutter test
```
