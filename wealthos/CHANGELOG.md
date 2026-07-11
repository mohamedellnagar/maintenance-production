# Changelog

All notable changes to WealthOS are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

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
