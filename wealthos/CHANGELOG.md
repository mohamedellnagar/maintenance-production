# Changelog

All notable changes to WealthOS are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.3.0] — Recurring Transactions & Bills Engine V1

### Added
- **Three-layer model** — `RecurringRule` (schedule/template), `Occurrence`
  (a planned due date that never affects balances), and `Transaction` (the real
  record). Unpaid occurrences are excluded from actual spending, income,
  balance and net worth.
- **Recurring types**: `income`, `expense`, `transfer`, and `liabilityPayment`
  (posted as an asset→liability transfer, never as income/expense).
- **`RecurrenceCalculator`** (pure, exhaustively tested): daily, weekly
  (interval + multiple weekdays), monthly (day-of-month **or** ordinal weekday
  like "last Friday"), yearly, and every-N-days. Day-of-month clamps to the
  month's last day (no spill); 29 Feb yearly falls back to 28 Feb in
  non-leap years. Dates use a UTC-based `LocalDate` and an injected `Clock`.
- **`RecurrenceGenerationService`**: idempotent, atomic, on-demand window
  generation (today → +90d, ~60d backfill) with no background timer.
- **Atomic posting** with a double-post guard; deleting the linked transaction
  reactively reopens the occurrence (status is largely derived, not stored).
- **Auto-create** (per-rule + global toggle, both off by default): posts
  due/overdue occurrences once on app open, never future, never when a
  referenced account/category is archived.
- **Snooze / Skip / Pause / Resume / End / Edit** with future-only schedule
  regeneration that leaves posted history untouched.
- **Screens**: bottom-nav **Recurring** tab (overdue / due today / upcoming
  7 & 30, planned totals labelled as *planned*, active rules), add/edit rule
  form, rule details, occurrence details (mark paid, edit-before-posting,
  snooze, skip).
- **Dashboard** reactive **Upcoming Bills** card; **Budget** screen & item
  details show **"Upcoming recurring"** separately (the `BudgetCalculator` is
  unchanged).
- **In-app insights** only (overdue, multiple due today, income upcoming,
  auto-create failed, archived reference, many unpaid) — no device
  notifications.
- **Database**: schema **v3** with `recurring_rules`,
  `recurring_rule_weekdays`, `recurring_occurrences`
  (`UNIQUE(recurring_rule_id, original_due_date)`, CHECKs, FKs) and an
  `auto_create_recurring_enabled` settings column, with real v2→v3 and
  v1→latest migrations + tests.
- Full ar/en localization; ~69 new unit/database/integration/widget tests
  (125 → 194); docs `recurring-model.md` + `recurring-implementation-plan.md`.

## [1.2.0] — Budgeting Engine V1

### Added
- **Monthly budgets** (one per year/month/currency) with `draft | active |
  closed` status, built on the existing ledger without changing it.
- **Budget item types**: `expense` (expense category), `incomePlan` (income
  category), `debtPayment` (liability account), `saving` (plan only in V1).
- **`BudgetCalculator`** (pure, tested): expected vs. actual income, total
  assigned, available-to-assign (account balances never leak in), per-item
  actual spending with category **self+descendants**, remaining, overspending,
  usage %, debt-payment actuals (repayments only, via `TransactionSemantic`).
- **Rollover** of positive expense surpluses through an explicit, atomic
  **close-month** flow with traceable `budget_rollovers` records; **reopen**
  with confirmation. Closed months are read-only; live actuals still update and
  raise a "results changed" insight.
- **Double-counting prevention**: unique category/liability items plus a
  parent/child hierarchy guard.
- **Screens**: bottom-nav **Budget** tab (month navigation, KPIs, sections,
  per-item progress + textual status), create (empty / copy previous), add/edit
  item, item details (contributing transactions + rollovers), close-month.
- **Dashboard** reactive **Budget Summary** card.
- **In-app insights** (central thresholds): overspend, ≥80% usage, negative
  available-to-assign, income below expected, closed-month changed.
- **Database**: schema **v2** with `budgets`, `budget_items`,
  `budget_rollovers` (FKs, unique constraints, CHECKs) and a real v1→v2
  migration + migration test.
- ~40 new unit/database/integration/widget tests; docs
  `budgeting-model.md` + `budgeting-implementation-plan.md`.

## [1.1.0] — Foundation Hardening

### Added
- **Explicit balance concepts** in the domain (`AccountBalance`):
  `signedBalanceMinor`, `displayBalanceMinor`, `netWorthContributionMinor`.
  Liabilities now display their outstanding debt as a positive figure; all sign
  conversion lives in the domain (no ad-hoc `abs()` in widgets).
- **Liability operations** documented and tested (credit-card purchase &
  repayment, loan receipt & repayment, interest) with a `TransactionSemantic`
  classifier for clear UI labels. New `docs/accounting-model.md`.
- **Outstanding-balance** entry for liabilities (positive input → signed
  opening) with "Outstanding balance / الرصيد المستحق" labels.
- **Adjustment reworked**: enter the actual balance; the app shows the current
  calculated balance, previews the difference, requires a reason, blocks a
  no-op, and stores the signed delta (`AdjustmentCalculator`).
- **Transaction details** screen (all fields, per-account effect, status),
  reachable from the dashboard, account detail and lists.
- **Edit transaction** (shared create/edit form) with atomic updates and full
  re-validation on type change.
- **Delete with confirmation + undo**, and **restore** (same row, not a new one).
- **Repository integrity**: archived account/category rejection, category
  type-match, category-only-on-cash-flow, currency match, and FK enforcement —
  all checked inside the write transaction with database tests.
- **Reactivity**: account-by-id and transaction-by-id are now live streams.
- ~40 new unit, database, integration (reactive) and widget tests.

### Changed
- `accountByIdProvider` is now a `StreamProvider`; `accountBalanceProvider`
  returns an `AccountBalance`.

## [1.0.0] — Foundation

### Added
- **Money value object** with integer minor-unit storage, exact parsing
  (ASCII + Arabic-Indic digits, thousands separators, negatives), formatting,
  and currency-mismatch protection.
- **Currency registry** with AED as the single selectable base currency and a
  seam for future currencies.
- **Drift/SQLite database** (schema v1): `app_settings`, `accounts`,
  `categories`, `transactions` with CHECK constraints and foreign keys.
- **Migrations** and **idempotent seeding** of 16 bilingual default categories.
- **Domain calculators**: transaction effects, account balance, net worth,
  monthly income/expense, and transaction validation — all pure and tested.
- **Repositories** for settings, accounts, categories and transactions, with
  atomic transfers, soft delete and the single-currency invariant.
- **Riverpod** state layer and **GoRouter** navigation with an onboarding gate.
- **Onboarding** (language → currency → first account), **Dashboard**
  (net worth, assets/liabilities, monthly cash flow, recent activity, empty
  state), **Accounts** (list/add/detail/archive), unified **Add Transaction**
  (income/expense/transfer/adjustment), and **Settings**.
- **Localization** (Arabic + English, RTL/LTR) via generated `AppLocalizations`.
- **Material 3** light/dark themes with accessible, non-color-only money cues.
- **Security**: biometric app-lock setting stored in secure storage, an
  `AppLockGate`, and a release-safe dev-only logger.
- **Tests**: unit (money, calculators, validator), database (migrations, CRUD,
  transfer atomicity, soft delete, seeding), and widget (onboarding, empty
  dashboard, add-account/transaction validation).
- **Docs**: architecture, database, business rules, testing, roadmap,
  implementation plan.

### Notes
- Offline-only: no network, analytics or crash reporting.
- `sqlite3` native assets build against the system `libsqlite3` for hermetic
  test/CI runs (see `docs/database.md`).
