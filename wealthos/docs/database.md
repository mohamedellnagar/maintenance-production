# Database

Local storage is **SQLite** via [Drift]. Schema version **3**. Foreign keys are
enabled (`PRAGMA foreign_keys = ON`). All money is stored as integer minor units.

## Recurring tables (v3)

- **`recurring_rules`** — `id`, `name`, `recurring_type`
  (`income|expense|transfer|liabilityPayment`), `account_id?→accounts`,
  `destination_account_id?→accounts`, `category_id?→categories`,
  `amount_minor`, `currency_code`, `recurrence_frequency`
  (`daily|weekly|monthly|yearly|customInterval`), `interval_value`,
  `monthly_day?`, `monthly_week_ordinal?`, `monthly_weekday?`, `yearly_month?`,
  `yearly_day?`, `start_date`, `end_date?`, `max_occurrences?`,
  `auto_create_transaction`, `reminder_days_before`, `notes?`, `is_active`,
  `last_generated_through?`, timestamps. Dates are stored as **epoch-day
  integers** (`LocalDate`).
- **`recurring_rule_weekdays`** — join table for weekly rules with multiple
  weekdays: `recurring_rule_id→recurring_rules`, `weekday` (1..7), PK
  `{recurring_rule_id, weekday}`.
- **`recurring_occurrences`** — `id`, `recurring_rule_id→recurring_rules`,
  `due_date`, `original_due_date`, `expected_amount_minor`, `status`
  (`scheduled|paid|skipped|cancelled`), `generated_transaction_id?→transactions`,
  `completed_at?`, `skipped_at?`, `skip_reason?`, `snoozed_until?`, timestamps.
  **`UNIQUE(recurring_rule_id, original_due_date)`** makes generation
  idempotent; a CHECK guards `status`.

`app_settings` also gains **`auto_create_recurring_enabled`** (default false).

`schemaVersion` is **3**; `onUpgrade` adds the settings column and creates the
three recurring tables when upgrading from < 3 (the budget tables are still
created when upgrading from < 2). Migration tests cover **v2→v3** and
**v1→latest** (`test/database/recurring_test.dart`,
`test/database/budget_test.dart`). Repository-enforced rules — idempotent
generation, atomic posting with a double-post guard, archived-reference
rejection, delete-blocked-when-posted — sit alongside these constraints.

## Budget tables (v2)

- **`budgets`** — `id`, `year`, `month`, `currency_code`, `status`
  (`draft|active|closed`), `notes?`, `closed_snapshot_expense_minor?`,
  `closed_snapshot_income_minor?`, timestamps. `UNIQUE(year, month,
  currency_code)`; CHECKs on `status` and `month BETWEEN 1 AND 12`.
- **`budget_items`** — `id`, `budget_id→budgets`, `item_type`
  (`expense|saving|debtPayment|incomePlan`), `category_id?→categories`,
  `account_id?→accounts`, `custom_name?`, `assigned_amount_minor` (`>= 0`),
  `rollover_enabled`, `display_order`, `notes?`, timestamps. `UNIQUE(budget_id,
  category_id)` and `UNIQUE(budget_id, account_id)` (SQLite NULLs are distinct,
  so multiple savings rows are allowed while duplicate category/liability items
  are blocked).
- **`budget_rollovers`** — `id`, `from_budget_id→budgets`,
  `to_budget_id→budgets`, `source_budget_item_id→budget_items`,
  `target_budget_item_id?→budget_items`, `amount_minor`, `created_at`.

`schemaVersion` is **2**; `onUpgrade` creates the three tables. A test upgrades a
`user_version = 1` database and asserts the tables appear (see
`test/database/budget_test.dart`). Repository-enforced budget rules (category
type, archived rejection, hierarchy, closed-month read-only, delete-with-linked-
rollover) sit alongside these constraints.

## Tables

### `app_settings` (single row, id = 1)
| column | type | notes |
| --- | --- | --- |
| id | int | fixed `1` |
| base_currency | text(3) | ISO-4217, default `AED` |
| language_code | text | `ar` / `en` |
| theme_mode | text | `system` / `light` / `dark` |
| biometric_enabled | bool | mirror of secure-store flag |
| onboarding_completed | bool | gates the router |
| created_at / updated_at | datetime | |

### `accounts`
| column | type | notes |
| --- | --- | --- |
| id | text (UUID) | PK |
| name | text(1..100) | |
| account_type | text | `cash,bank,wallet,creditCard,investment,asset,loan,other` |
| classification | text | `asset` / `liability` |
| currency_code | text(3) | must equal base currency (this phase) |
| opening_balance_minor | int | **signed** net-worth contribution |
| institution_name | text? | |
| account_number_last4 | text?(≤4) | |
| icon | text? | |
| display_order | int | |
| is_archived | bool | |
| created_at / updated_at | datetime | |

CHECK: `account_type` and `classification` restricted to their enum sets.

### `categories`
| column | type | notes |
| --- | --- | --- |
| id | text | PK (system ids are stable, e.g. `sys_exp_food`) |
| name_ar / name_en | text | localized names |
| category_type | text | `income` / `expense` |
| parent_id | text? | reserved for sub-categories |
| icon | text? | |
| is_system | bool | |
| is_archived | bool | |
| created_at / updated_at | datetime | |

### `transactions`
| column | type | notes |
| --- | --- | --- |
| id | text (UUID) | PK |
| transaction_type | text | `income,expense,transfer,adjustment` |
| account_id | text? → accounts | source account |
| destination_account_id | text? → accounts | transfers only |
| category_id | text? → categories | income/expense only |
| amount_minor | int | magnitude (>0) except adjustment (signed, ≠0) |
| currency_code | text(3) | |
| transaction_date | datetime | |
| note | text? | |
| adjustment_reason | text? | required for adjustments |
| created_at / updated_at | datetime | |
| deleted_at | datetime? | soft delete |

## CHECK constraints (integrity)

- `transaction_type` ∈ the four types.
- `amount_minor <> 0`; and `amount_minor > 0` unless the type is `adjustment`.
- non-transfer rows must have a source `account_id`.
- transfers require both endpoints and `account_id <> destination_account_id`.
- only transfers may set `destination_account_id`.
- adjustments must have a non-empty `adjustment_reason`.

These mirror `TransactionValidator` so the UI shows friendly messages while the
database still refuses invalid rows as a last line of defence.

## Cross-table integrity (repository-enforced)

Some rules depend on other tables and cannot be expressed as single-table SQL
`CHECK`s, so `TransactionsRepository` enforces them inside the same database
transaction as the write (covered by `test/database/hardening_test.dart`):

- no transaction on an **archived** account (source or transfer destination);
- no **archived** category, and the category **type must match** the
  transaction type (income vs. expense);
- transaction currency equals each account's currency and the base currency.

Schema version stays **1** — this phase added no columns or constraints. Foreign
keys are `PRAGMA`-enabled in `beforeOpen`; a test asserts a bad reference is
rejected. Structural rules that *are* single-table remain `CHECK` constraints.

## Migrations

`onCreate` builds all tables and seeds default categories. `beforeOpen` enables
foreign keys and re-runs the (idempotent) seed for pre-existing databases.
Future schema changes bump `schemaVersion` and add steps to `MigrationStrategy`.

## Seeding

16 default categories (10 expense, 6 income), bilingual, with **stable ids** and
`InsertMode.insertOrIgnore` — running the seed repeatedly never duplicates.

## Native build note

`pubspec.yaml` sets `hooks.user_defines.sqlite3.source: system` so the `sqlite3`
package builds against the OS-provided `libsqlite3`. This keeps host/CI test
runs hermetic (no binary download). Mobile builds still bundle SQLite via
`sqlite3_flutter_libs`.

[Drift]: https://drift.simonbinder.eu
