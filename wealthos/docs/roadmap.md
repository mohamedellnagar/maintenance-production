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

## Deliberately deferred

Not built in this phase (only logical extension points left where useful):

- Cloud login & sync, backend/API
- AI / financial intelligence, bank linking, stock prices, online FX
- Subscriptions, ads
- Financial goals, loan repayment schedules, forecasting
- Push / device notifications (recurring reminders are in-app only)
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
