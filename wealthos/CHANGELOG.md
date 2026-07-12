# Changelog

All notable changes to WealthOS are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.5.0] — Device QA & Release Readiness

### Added
- **Migration/integrity tests**: real v1→v5, v2→v5, v3→v5, v4→v5 upgrades plus
  `PRAGMA foreign_key_check` / `integrity_check` and cross-feature invariant
  checks (cache==ledger, no orphan paid occurrence, no over-allocated
  transaction, no budget item → missing goal, transfer-group consistency) on a
  seeded database (`test/database/integrity_test.dart`).
- **Restart persistence** test over a real on-disk SQLite file, including the
  recurrence generator resuming on reopen (`test/integration/persistence_test.dart`).
- **QA widget tests**: Arabic More-tab access, goals home at 2.0 text scale with
  no overflow, dark-mode smoke, RTL layout (`test/widget/qa_test.dart`).
- Docs: `device-qa-plan.md`, `device-smoke-test.md`, `android-build-setup.md`,
  `qa-checklist.md`, `release-readiness.md`.

### Changed
- **Navigation**: the bottom bar is now **5 tabs** (Dashboard, Budget, Goals,
  Accounts, **More**) instead of 6, keeping Arabic labels legible at large text
  scales. Recurring and Settings moved under a new **More** tab with full access
  preserved.
- **Schema v5**: goal transfers are a paired unit via `transfer_group_id` —
  deleting/restoring one leg now moves **both** legs atomically (fixes a data
  divergence risk). Real v4→v5 migration + regression tests.
- **Goal fund cache integrity**: `verifyFunds` / `repairAllFunds` plus a startup
  reconcile so no screen reads a stale allocation; the ledger stays the source
  of truth.
- **Responsive**: goal card money row and summary pills use `Wrap` so long
  values / 2.0 text scale reflow instead of overflowing.

### Security / release
- **Privacy screen**: `FLAG_SECURE` hides content in recents and blocks
  screenshots/recording.
- **Backups off**: `allowBackup=false` + data-extraction rules keep the local
  financial DB off cloud/device-transfer backups; `usesCleartextTraffic=false`.
- App label set to **WealthOS**; conditional release signing from a gitignored
  `android/key.properties` (no secrets in the repo).
- **Not Executed**: APK/AAB builds and on-device steps — the environment has no
  Android SDK and the download host is blocked by network policy (documented).

## [1.4.0] — Financial Goals & Savings Funds V1

### Added
- **Three-layer model** — Account (real money), **Financial Goal** (a target),
  and **Savings Fund** (a virtual 1:1 allocation bucket). Allocating money never
  creates a transaction, moves an account, or changes net worth.
- **Fund ledger** (`goal_fund_entries`) as the source of truth for a fund's
  balance (contribution / withdrawal / transferIn / transferOut / adjustment,
  each a positive amount with explicit direction); `goal_funds` holds a cached,
  rebuildable balance. Soft-deleted entries contribute zero.
- **`GoalAllocationCalculator`**: eligible liquid assets (positive cash/bank/
  wallet balances only), total allocated, unallocated, and an **Allocation
  Shortfall** when allocations exceed eligible liquid. Contributions beyond
  available liquid are explicitly rejected.
- **`GoalProgressCalculator`** (pure): funded / remaining / overfunded, required
  monthly (whole months, rounded up), projected completion from the trailing
  3-month contribution average (transfers/withdrawals excluded; "cannot
  estimate" when zero), and an on-track status via central `GoalThresholds`.
- **Transfers between goals** (atomic, cross-linked, total-allocation
  preserving); withdrawals bounded by balance; adjustments with a required note.
- **Debt-payoff goals** can link a liability and show **Saved for repayment**
  vs. **Actual debt reduced** (real repayments via `TransactionSemantic`);
  earmarking is never counted as repayment.
- **Goal statuses** (draft/active/paused/completed/cancelled/archived) with no
  hard delete once a ledger exists; cancel-with-balance offers keep or
  un-allocate.
- **Screens**: bottom-nav **Goals** tab (summary, sections, insights, cards),
  create/edit form, goal details with fund ledger + actions (contribute,
  withdraw, transfer, pause/resume, complete, cancel, archive, soft
  delete/restore entries). Reactive **Goals** dashboard card. Budget saving
  items can link a goal and show its monthly contributed/withdrawn.
- **In-app insights** only: allocation shortfall, behind, near completion,
  completed, stalled, deadline soon, overfunded, emergency-fund low.
- **Database**: schema **v4** with `financial_goals`, `goal_funds`,
  `goal_fund_entries`, `goal_transaction_allocations` and a
  `budget_items.linked_goal_id` column; real v3→v4 and v1→latest migrations.
- Full ar/en localization; ~55 new unit/database/integration/widget tests
  (194 → 249); docs `goals-model.md` + `goals-implementation-plan.md`.

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
