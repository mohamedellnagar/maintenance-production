# Database

Local storage is **SQLite** via [Drift]. Schema version **1**. Foreign keys are
enabled (`PRAGMA foreign_keys = ON`). All money is stored as integer minor units.

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
