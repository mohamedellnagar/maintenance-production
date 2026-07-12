# Roadmap

## Phase 1 — Foundation (this release) ✅

Offline-first core: Money value object, Drift database + migrations + seeding,
accounts, transactions (income/expense/transfer/adjustment), derived balances,
net worth & monthly cash flow, onboarding, dashboard, settings, ar/en + RTL,
Material 3 light/dark, biometric app-lock setting, full test suite.

## Phase 1.1 — Foundation Hardening (this release) ✅

Unified asset/liability balance model (signed / display / net-worth), liability
operations (credit cards, loans) with clear semantics, actual-balance
adjustments, transaction details/edit/delete/restore, repository-level
integrity (archived/category-type/currency/FK), reactive providers, and a much
larger test suite. See `docs/accounting-model.md`.

## Phase 1.2 — Budgeting Engine V1 (this release) ✅

Monthly budgets with expense/income-plan/saving/debt-payment items, actual vs.
plan math, available-to-assign, category self+descendants, overspend/usage,
debt-payment tracking (repayments only), traceable rollover via an atomic
close-month flow, reopen, in-app insights, a Budget tab and a dashboard summary
card. See `docs/budgeting-model.md`. Deferred to a later budgeting phase:
actual-savings linkage, deficit carry-over, budget templates, and reports.

## Phase 1.3 — Recurring Transactions & Bills Engine V1 (this release) ✅

Recurring rules for income/expense/transfer/liability-payment and bills, cleanly
separated into rules → planned occurrences → real transactions (unpaid
occurrences never affect balances or net worth). Pure recurrence math
(daily/weekly/monthly-by-day-or-ordinal/yearly/every-N-days with month-length
and leap-year clamping), idempotent on-demand generation, atomic posting with a
double-post guard, opt-in auto-create, snooze/skip/pause/resume/end/edit, a
Recurring tab, an Upcoming Bills dashboard card, an "Upcoming recurring" view in
Budgets, and in-app insights. Schema **v3**. See `docs/recurring-model.md`.
Deferred to a later recurring phase: forecasting/projections, variable-amount
estimation, and device/push reminders.

## Phase 1.4 — Financial Goals & Savings Funds V1 (this release) ✅

Save toward goals via *virtual* savings funds that never create fake balances or
change net worth. A fund ledger (contribute/withdraw/transfer/adjust) is the
source of truth; available-to-allocate with an Allocation Shortfall warning;
progress, required-monthly and projected-completion math; debt-payoff goals that
separate *saved* from *actual debt reduced*; goal statuses with no destructive
delete; a Goals tab, dashboard card, insights, and budget saving-item linkage.
Schema **v4**. See `docs/goals-model.md`. Deferred to a later goals phase:
recurring auto-contributions, planning-only over-allocation, and forecasting.

## Phase 1.5 — Device QA & Release Readiness (this release) ✅

Hardened the app for a real Android release after schema v5: a data-safety fix
pairing goal-transfer legs (`transfer_group_id`) with atomic delete/restore, a
goal fund cache verify/repair path reconciled at startup, a 5-tab + More
navigation that keeps Arabic labels legible, a `FLAG_SECURE` privacy screen with
backups disabled and no network permission, conditional release signing with no
secrets in the repo, and migration/integrity/persistence/QA test suites. APK/AAB
builds are documented for local runs (Android SDK unavailable in CI). See
`docs/release-readiness.md`, `docs/device-qa-plan.md`, `docs/qa-checklist.md`.

## Deliberately deferred

Not built in this phase (only logical extension points left where useful):

- Cloud login & sync, backend/API
- AI / financial intelligence, bank linking, stock prices, online FX
- Subscriptions, ads
- Loan repayment schedules, forecasting/projections
- Push / device notifications (recurring & goal reminders are in-app only)
- PDF/Excel export, cloud backup

## Candidate next steps

1. **Reports** — trends over time, per-category breakdowns, date-range filters.
2. **Recurring V2** — forecasting/projected cash flow, variable-amount rules.
3. **Budgets V2** — actual-savings linkage, deficit carry-over, templates.
4. **Multi-currency** — unlock currency selection; per-account currency with an
   explicit FX/valuation strategy for net worth.
5. **Cached balances** — materialised balances behind `BalanceCalculator` with a
   verify/rebuild path, once transaction volume justifies it.
6. **Privacy screen** — app-switcher blur, re-lock on resume/timeout (the
   `AppLockGate` is already the seam).
7. **Backup/restore** — local encrypted export before any cloud story.
