# Database

Local storage is **SQLite** via [Drift]. Schema version **5**. Foreign keys are
enabled (`PRAGMA foreign_keys = ON`). All money is stored as integer minor units.

## Goal transfer pairing (v5)

`goal_fund_entries` gains **`transfer_group_id`** (nullable): the two legs of an
inter-goal transfer share one group id so they are always soft-deleted /
restored **together** (a single leg can never be removed, which would make the
two funds diverge). `onUpgrade` adds the column when upgrading from v4; a v1–v3
upgrade creates `goal_fund_entries` already including it. Covered by a v4→v5
migration test and a paired delete/restore test in `test/database/goals_test.dart`.

The goal fund cache (`goal_funds.current_allocated_minor`) is reconciled with
the ledger at startup (`GoalsRepository.repairAllFunds`) and can be audited with
`verifyFunds`; `test/database/integrity_test.dart` asserts cache == ledger on a
seeded database along with `PRAGMA foreign_key_check` / `integrity_check`.

## Goals tables (v4)

- **`financial_goals`** — `id`, `name`, `goal_type`
  (`emergencyFund|home|car|travel|education|wedding|retirement|debtPayoff|
  purchase|custom`), `target_amount_minor` (`> 0`), `currency_code`,
  `target_date?` (epoch day), `priority` (`low|medium|high|critical`), `status`
  (`draft|active|paused|completed|cancelled|archived`),
  `linked_liability_account_id?→accounts`, `notes?`, timestamps,
  `completed_at?`, `cancelled_at?`. CHECKs guard the enum columns and the target.
- **`goal_funds`** — the 1:1 allocation bucket: `id`, `goal_id→financial_goals`
  (`UNIQUE`), `current_allocated_minor` (cached ledger sum), timestamps.
- **`goal_fund_entries`** — the fund **ledger** (source of truth): `id`,
  `goal_id→financial_goals`, `entry_type`
  (`contribution|withdrawal|transferIn|transferOut|adjustment`), `direction?`
  (`increase|decrease`, adjustments only), `amount_minor` (`> 0`),
  `linked_transaction_id?→transactions`, `related_goal_id?→financial_goals`
  (transfers), `entry_date` (epoch day), `note?`, `created_at`, `deleted_at?`
  (soft delete). A CHECK requires a `direction` for adjustments.
- **`goal_transaction_allocations`** — links a contribution to a real
  transaction without re-booking it: `id`, `goal_id`, `transaction_id`,
  `amount_minor` (`> 0`), `created_at`, `UNIQUE(goal_id, transaction_id)`. The
  repository keeps the sum of a transaction's allocations `≤` its amount.

`budget_items` also gains **`linked_goal_id?→financial_goals`**.

`schemaVersion` is **4**; `onUpgrade` creates the four goal tables when
upgrading from `< 4` and adds `budget_items.linked_goal_id` (only when the table
pre-existed — on a v1 upgrade it is created with the column already present).
Migration tests cover **v3→v4** and **v1→latest**
(`test/database/goals_test.dart`, `test/database/budget_test.dart`).
Repository-enforced rules — ledger-derived balances, allocation-vs-available
prevention, atomic transfers, transaction-allocation limits, and
delete-blocked-when-ledger-exists — sit alongside these constraints.

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
