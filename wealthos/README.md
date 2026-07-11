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
- 📊 **Net worth** — assets, liabilities and net worth on one signed number line.
- 🌍 **Bilingual** — real Arabic + English strings (RTL/LTR), no hardcoded UI
  text.
- 🎨 **Material 3** — light/dark themes, accessible gain/loss cues (never
  color-only).
- 🔐 **Private by design** — biometric app-lock, secure storage, dev-only logs,
  zero network/analytics.

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
              settings   (each: domain / data / application / presentation)
test/         unit / database / widget
docs/         architecture, database, business-rules, testing, roadmap, plan
```

## Scope of the current phase

**Included:** offline core — money, database, accounts, transactions, balances,
net worth, monthly cash flow, onboarding, dashboard, settings, localization,
theming, biometric lock, tests.

**Not included (deferred):** cloud login/sync, backend/API, AI, bank linking,
stock prices, online FX, subscriptions, ads, advanced budgets, goals, loan
schedules, forecasting, PDF/Excel export, cloud backup. See `docs/roadmap.md`.

## Documentation

- `docs/architecture.md` — layers, structure, state, navigation
- `docs/database.md` — schema, constraints, migrations, seeding
- `docs/business-rules.md` — money, accounts, transactions, net worth rules
- `docs/testing.md` — what is tested and how
- `docs/roadmap.md` — what is next
- `CHANGELOG.md`
