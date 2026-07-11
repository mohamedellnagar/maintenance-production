# WealthOS — Implementation Plan (Foundation Phase)

This document captures the plan followed for the foundation phase. It is
intentionally scoped: only what is actually built is listed.

## Goals

Deliver a production-quality, **offline-first** personal-finance foundation in
Flutter with correct money handling, a real local database, and the core flows
(onboarding → accounts → transactions → dashboard). No cloud, no accounts, no
network.

## Sequence

1. **Scaffold** the Flutter project (`wealthos/`), strict analysis, lints.
2. **Money** value object (integer minor units, parsing, formatting, currency
   safety) — the single most-tested primitive.
3. **Domain** enums & entities (accounts, transactions, categories, settings)
   plus pure calculators (balance, transaction effect, net worth, cash flow).
4. **Database** with Drift: tables, CHECK constraints, migrations, idempotent
   category seeding.
5. **Repositories** mapping rows ⇆ domain, enforcing validation and running
   transfers atomically. Soft delete for financial rows.
6. **State** with Riverpod providers (DI + derived state).
7. **Localization** (ARB → generated `AppLocalizations`, ar + en, RTL/LTR).
8. **Theme** (Material 3 light/dark, spacing/color tokens).
9. **UI**: onboarding, dashboard, accounts (list/add/detail), unified add
   transaction, settings.
10. **Security**: biometric app-lock setting via secure storage + `local_auth`;
    safe dev-only logger.
11. **Tests**: unit (money, calculators, validator), database (migrations,
    CRUD, transfer atomicity, soft delete, seeding), widget (onboarding, empty
    dashboard, add-account/transaction validation).
12. **Quality gate**: `dart format`, `flutter analyze`, `flutter test`.
13. **Docs**: this file plus architecture / database / business-rules /
    testing / roadmap / README / CHANGELOG.

## Explicitly out of scope

Cloud sync/login, backend/API, AI, bank linking, stock prices, online FX,
subscriptions, ads, advanced budgets, goals, loan schedules, forecasting,
PDF/Excel export, cloud backup. Only logical extension points are left behind.
