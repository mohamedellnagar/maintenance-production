# Architecture

WealthOS uses a pragmatic **feature-first clean architecture**. Layers are
created only where they earn their keep — no empty folders for symmetry.

## Layers

```
presentation  →  application  →  domain  ←  data
   (widgets)      (Riverpod)     (pure)     (Drift)
```

- **domain** — pure Dart: entities (`Account`, `Transaction`, `Category`,
  `AppSettings`), enums, and the financial calculators
  (`Money`, `AccountBalance`, `TransactionEffect`, `BalanceCalculator`,
  `NetWorthCalculator`, `AdjustmentCalculator`, `TransactionSemantic`,
  `TransactionValidator`). No Flutter, no I/O. Fully unit-testable. Balance
  sign/display conversions live here so widgets never re-derive them — see
  `accounting-model.md`.
- **data** — repositories backed by the Drift database. They map rows ⇆ domain
  entities, enforce validation, and own persistence concerns (atomic transfers,
  soft delete, currency invariants).
- **application** — Riverpod providers that expose repositories and derived
  state (balances, dashboard KPIs). Dependency injection lives here.
- **presentation** — widgets/screens. They read providers and render; they hold
  **no** business logic and issue **no** database queries directly.

## Directory layout

```
lib/
  app/                     # root widget wiring theme, l10n, router, lock gate
  core/
    database/              # Drift tables, database, connection, seed
    di/                    # infrastructure providers (db + repositories)
    errors/                # Failure hierarchy + Result<T>
    localization/          # ARB sources, generated l10n, enum & failure labels
    money/                 # Money value object + currency registry
    routing/               # GoRouter configuration
    security/              # biometric service + app-lock gate
    theme/                 # spacing, colors, Material 3 themes
    utils/                 # safe dev-only logger
    widgets/               # shared presentation widgets
  features/
    onboarding/ dashboard/ accounts/ transactions/ categories/ budgets/
    recurring/ goals/ settings/
      domain/ data/ application/ presentation/   # only where used
```

## State management

[Riverpod] provides both DI and reactive state. Streams from Drift
(`watch*`) flow through `StreamProvider`s; pure derivations (balances, net
worth) are computed in plain `Provider`s from those streams, so the UI stays a
thin projection of the database.

## Navigation

[GoRouter] with a single redirect: until `onboarding_completed` is true the app
is pinned to `/onboarding`; afterwards `/onboarding` redirects home. The router
refreshes when settings change. Main navigation is a `StatefulShellRoute`
bottom-nav shell with six tabs — Dashboard, **Budget**, **Recurring**,
**Goals**, Accounts, Settings — and detail/form screens push full-screen above
the shell (root navigator).

The **budgets** feature adds `BudgetCalculator` (pure month math),
`BudgetInsightBuilder`, a `BudgetsRepository` (one-per-month, integrity, atomic
close/rollover) and a reactive `budgetViewProvider` that recomputes whenever
transactions, categories, accounts, items or rollovers change. See
`accounting-model.md` and `budgeting-model.md`.

The **recurring** feature adds a pure `RecurrenceCalculator` (schedule math on
`LocalDate` with an injected `Clock`), a `RecurringRepository` (idempotent
generation, atomic posting into the Transaction Repository with a double-post
guard), a `RecurrenceGenerationService` (on-demand window generation +
opt-in auto-create — no background timer), and `RecurringInsightBuilder`.
Occurrence display status is largely **derived** from the linked transaction's
liveness, so delete/restore of a posted transaction reactively reopens/repays
the occurrence with no extra writes. Unpaid occurrences never enter budget
actuals or balances. See `recurring-model.md`.

The **goals** feature adds pure `GoalAllocationCalculator` and
`GoalProgressCalculator`, a `GoalsRepository` (a fund **ledger** as the source of
truth with a cached balance, allocation-vs-available enforcement, atomic
inter-goal transfers, transaction-allocation limits), and `GoalInsightBuilder`.
A Savings Fund is a **virtual** allocation bucket — allocating money writes only
a ledger entry, so accounts, balances and net worth are untouched. Goal views,
the goals summary and the Allocation Shortfall warning are all derived reactively
from goals + funds + entries + accounts + transactions. See `goals-model.md`.

## Error handling

Expected failures use `Result<T>` + a sealed `Failure` hierarchy carrying a
stable `code`. User-facing text is resolved from the code in the presentation
layer (`FailureL10n`), so no localized strings leak into domain/data.

## Offline-first & privacy

Everything runs locally against SQLite. No network calls, analytics, or crash
reporting. The biometric preference is stored in the platform secure store; the
`AppLockGate` is also the seam for a future privacy screen (app-switcher blur).

[Riverpod]: https://riverpod.dev
[GoRouter]: https://pub.dev/packages/go_router
