# Recurring Transactions & Bills — Domain Model

WealthOS models recurring money flows without ever creating incorrect or
duplicate financial records. The design separates three distinct concepts:

| Concept | What it is | Affects balances / net worth? |
| --- | --- | --- |
| **RecurringRule** | The *schedule + template*: what repeats, for how much, on what cadence. | No |
| **Occurrence** | A single *planned due date* generated from a rule. A plan, not a fact. | **No** (until posted) |
| **Transaction** | A *real financial record* created when an occurrence is posted. | Yes |

An unpaid occurrence is never counted as actual expense, income, balance, or net
worth. It only becomes real when the user (or auto-create) posts it into a
transaction through the existing Transaction Repository.

## Recurring types

`RecurringType` (`lib/features/recurring/domain/recurring_type.dart`):

- **income** — credits an asset account under an income category.
- **expense** — debits an asset account (or charges a liability) under an
  expense category.
- **transfer** — moves money between two of the user's accounts.
- **liabilityPayment** — an asset → liability transfer (paying down debt). It is
  posted as a **transfer**, never as income/expense, so it is not misleadingly
  counted as spending. It maps to the accounting model's
  `liabilityRepayment` semantic.

## Frequencies & date rules

`RecurrenceFrequency` + `RecurrencePattern`, evaluated by the pure, exhaustively
unit-tested `RecurrenceCalculator`:

- **daily** — every day.
- **weekly** — every *N* weeks on one or more selected weekdays (Mon=1..Sun=7),
  anchored to the Monday of the start week.
- **monthly** — either by **day-of-month** (e.g. the 15th) or by **ordinal
  weekday** (e.g. "last Friday", ordinal `-1`).
- **yearly** — a specific month + day.
- **customInterval** — every *N* days.

Edge cases (guaranteed by tests in
`test/unit/recurrence_calculator_test.dart`):

- A missing day-of-month is **clamped to the last day of the month** and never
  spills into the next month (e.g. day 31 in February → Feb 28/29).
- A **29 Feb** yearly rule falls on 29 Feb in leap years and 28 Feb otherwise.
- `maxOccurrences` counts from the rule's very first occurrence, not from the
  generation window.

Dates use `LocalDate` (an epoch-day integer computed via UTC) so no timezone or
DST conversion can shift a calendar day. "Today" is injected through a `Clock`
typedef — domain logic never calls `DateTime.now()` directly.

## Occurrence status

Stored statuses (`OccurrenceStatus`): `scheduled`, `paid`, `skipped`,
`cancelled`. The **display** status (`OccurrenceDisplayStatus`) is largely
**derived** at read time:

- `scheduled` due date in the future → **scheduled**
- `scheduled` due date today → **due**
- `scheduled` due date in the past → **overdue**
- `paid` **and** its linked transaction is still alive → **paid**
- `paid` but the linked transaction was deleted → reopens (recomputes to
  due/overdue) — **no write to the occurrence is needed**

This derivation is what makes delete/restore of a posted transaction reactive:
deleting the transaction reopens the occurrence and restoring it (or re-posting)
marks it paid again, all without mutating occurrence rows.

## Generation

`RecurrenceGenerationService` generates occurrences into a rolling window
(today → +90 days, with a ~60-day back-window so a long app absence still
surfaces missed bills as overdue). It is:

- **Idempotent** — a `UNIQUE(recurring_rule_id, original_due_date)` constraint
  plus `insertOrIgnore` means re-running never duplicates.
- **Atomic** — generation + `last_generated_through` advance run in one DB
  transaction.
- **On-demand** — runs on app open / when the Recurring screen opens. There is
  **no background timer** and no future-years pre-generation.

## Posting

"Mark as paid / received" (`RecurringRepository.postOccurrence`):

1. Loads the occurrence and refuses if it is skipped/cancelled, or already
   posted with a still-alive transaction (**double-post guard**).
2. Builds the correct `NewTransactionInput` for the rule type and creates the
   transaction through the existing Transaction Repository.
3. Marks the occurrence `paid` and links `generated_transaction_id`.

All three steps run inside **one atomic DB transaction** (Drift savepoints), so
a failure at any point leaves no partial record. Edit-before-posting overrides
the amount/date/note for that single posting only.

## Auto-create

Two gates, both off by default for safety:

- Per-rule `autoCreateTransaction`.
- Global `autoCreateRecurringEnabled` (Settings).

When both are on, app open posts **due/overdue** occurrences once — never
future ones, never twice (the double-post guard), and never when a referenced
account/category is archived (the post fails and the occurrence is left for the
user, surfaced as an insight).

## Snooze / Skip / Pause / Resume / End / Edit

- **Snooze** moves a single occurrence's effective due date (`snoozed_until`).
- **Skip** marks one occurrence skipped (optional reason); it never posts.
- **Pause / Resume** toggle the rule's `is_active` flag.
- **End** deactivates the rule, sets its end date, and cancels future untouched
  occurrences.
- **Edit**: when the schedule changes, future **unposted** occurrences are
  dropped and regenerated atomically; paid/skipped/past occurrences and their
  transactions are untouched. An amount-only change reprices future unposted
  occurrences.
- **Delete** is refused if any occurrence has a linked transaction (end it
  instead).

## Budget & Dashboard integration

- Unpaid occurrences are **excluded** from budget actuals, balances, and net
  worth. The `BudgetCalculator` is not modified.
- The Budget screen and budget item details show them separately as **"Upcoming
  recurring"**, clearly labelled as planned (not actual) cash flow.
- The Dashboard shows an **Upcoming Bills** card (overdue / due today / next 7
  days) that reacts to posting and deletion.

## Insights (in-app only)

`RecurringInsightBuilder` derives textual, in-app insights: overdue bill,
multiple due today, income upcoming, auto-create failed, archived reference, and
many unpaid. There are **no device/push notifications** in V1.

## Goals integration (deferred)

The recurring engine intentionally has **no** link to Financial Goals in V1 (no
new "recurring goal contribution" type, no schema change here). The recommended
flow is a recurring transfer into a savings account whose posted transaction the
user links to a goal. See `goals-model.md`.
