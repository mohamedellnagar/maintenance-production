# WealthOS

**WealthOS** is an offline-first personal finance operating system built with
Flutter. It is not just an expense tracker: it manages your accounts, records
income/expenses/transfers/adjustments, derives balances from source data, and
reports **Total Assets, Total Liabilities and Net Worth** — with room to grow
into budgets, goals, forecasting and financial intelligence later.

The first release works **fully offline**: no account, no internet, no cloud.

## Highlights

- 💵 **Correct money** — integer minor units (fils/cents), never `double`; a
  `Money` value object with safe parsing, formatting, and currency-mismatch
  protection.
- 🗄️ **Real local database** — Drift/SQLite with migrations, CHECK constraints,
  and idempotent seeding.
- 🧮 **Derived balances** — an account's balance is computed from its opening
  balance + transactions, never stored as an editable field.
- 📊 **Net worth** — assets, liabilities and net worth on one signed number
  line; liabilities show their outstanding balance as a positive figure.
- 💳 **Liabilities done right** — credit-card purchases, repayments, loan
  receipts/repayments and interest with clear, non-misleading semantics
  (`docs/accounting-model.md`).
- ✏️ **Full transaction lifecycle** — details, edit (atomic), delete with undo,
  and restore; balance adjustments by entering the actual balance.
- 🥧 **Monthly budgets** — plan income/expenses/savings/debt payments, track
  actual vs. plan, available-to-assign, overspend, and carry surpluses forward
  via an atomic close-month flow (`docs/budgeting-model.md`).
- 🔁 **Recurring & bills** — rules for recurring income/expense/transfer/debt
  payments and bills, generated as *planned* occurrences that never touch
  balances until posted (one atomic transaction, no double-posting), with
  snooze/skip/pause, optional auto-create, and an Upcoming Bills dashboard card
  (`docs/recurring-model.md`).
- 🎯 **Goals & savings funds** — save toward targets via *virtual* allocation
  funds that never create fake balances or change net worth; a fund ledger
  (contribute/withdraw/transfer), available-to-allocate with an Allocation
  Shortfall warning, progress + projected completion, and debt-payoff goals that
  separate *saved* from *actual debt reduced* (`docs/goals-model.md`).
- 🌍 **Bilingual** — real Arabic + English strings (RTL/LTR), no hardcoded UI
  text.
- 🎨 **Material 3** — light/dark themes, accessible gain/loss cues (never
  color-only).
- 🔐 **Private by design** — biometric app-lock, a `FLAG_SECURE` privacy screen
  (no content in recents/screenshots), on-device backups disabled, secure
  storage, dev-only logs, and zero network permission or analytics.

## Tech stack

Flutter (stable) · Dart (strict analysis) · Riverpod · GoRouter · Drift + SQLite
· intl · flutter_localizations · local_auth · flutter_secure_storage · uuid ·
decimal.

## Getting started

```bash
cd wealthos
flutter pub get
flutter run
```

Demo flow: onboarding (language → currency → first account) → dashboard.

## Code generation

Drift and the localizations are generated:

```bash
# Drift database code (*.g.dart)
dart run build_runner build

# Localizations from lib/core/localization/arb/*.arb
flutter gen-l10n
```

## Running the tests

```bash
flutter test              # all unit + database + widget tests
flutter test test/unit    # a subset
```

See `docs/testing.md` for the full matrix.

## Quality

```bash
dart format .
flutter analyze     # strict mode; expected: "No issues found!"
flutter test
```

## Folder structure

```
lib/
  app/        root widget (theme, l10n, router, app-lock)
  core/       money, database, errors, localization, routing, security,
              theme, utils, widgets, di
  features/   onboarding, dashboard, accounts, transactions, categories,
              budgets, recurring, goals, settings
              (each: domain / data / application / presentation)
test/         unit / database / integration / widget
docs/         architecture, database, business-rules, testing, roadmap, plans
```

## Scope of the current phase

**Included:** offline core — money, database, accounts, transactions, balances,
net worth, monthly cash flow, monthly budgets, recurring transactions & bills,
financial goals & savings funds, onboarding, dashboard, settings, localization,
theming, biometric lock, tests.

**Not included (deferred):** cloud login/sync, backend/API, AI, bank linking,
stock prices, online FX, subscriptions, ads, loan schedules, forecasting,
push/device notifications, PDF/Excel export, cloud backup. See
`docs/roadmap.md`.

## Documentation

- `docs/architecture.md` — layers, structure, state, navigation
- `docs/accounting-model.md` — signed vs. display balances, liabilities, net
  worth, adjustments, delete/restore (with worked examples)
- `docs/budgeting-model.md` — monthly budgets, actual vs. plan, rollover,
  debt-payment, double-counting, closed months (with worked examples)
- `docs/recurring-model.md` — rules vs. occurrences vs. transactions,
  recurrence math, generation, posting, auto-create, insights
- `docs/goals-model.md` — goal vs. fund vs. account, the fund ledger,
  available-to-allocate, allocation shortfall, progress/projection, debt goals
- `docs/device-qa-plan.md` · `docs/device-smoke-test.md` ·
  `docs/qa-checklist.md` · `docs/release-readiness.md` — QA & release readiness
- `docs/android-build-setup.md` — exact macOS/Windows build & signing steps
- `docs/database.md` — schema, constraints, migrations, seeding, integrity
- `docs/business-rules.md` — money, accounts, transactions, net worth rules
- `docs/testing.md` — what is tested and how
- `docs/foundation-hardening-plan.md` — hardening findings & plan
- `docs/roadmap.md` — what is next
- `CHANGELOG.md`

> **Building an APK:** `flutter build apk --debug` needs the Android SDK. It is
> not installed in the CI sandbox used here and its download host
> (`dl.google.com`) is blocked by the egress policy, so the APK build cannot run
> in that environment. On a normal machine with the Android SDK it builds
> unchanged. `flutter analyze` and `flutter test` are the compile/behaviour gate.
