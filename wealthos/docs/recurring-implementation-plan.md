# Recurring Transactions & Bills Engine V1 — Implementation Plan

Built on top of the existing accounts/transactions/budgets model without changing
the accounting model or breaking the 125 existing tests. No push notifications,
cloud sync, AI or forecasting.

## Rule vs. Occurrence vs. Transaction

- **RecurringRule** — a schedule ("Rent 4,000 on the 1st of each month"). Holds
  the type, accounts/category, amount, recurrence pattern, start/end/max, and
  flags. It never touches balances.
- **RecurringOccurrence** — one due date generated from a rule (Rent, 2026-08-01).
  It is a *plan*, not money: it never affects balances, net worth, actual income
  or actual spending.
- **Transaction** — the real financial record. An occurrence affects nothing
  until it is **posted** into a transaction via the existing
  `TransactionsRepository`.

## Dates & time

A pure `LocalDate` (year/month/day) is used everywhere in recurrence logic and
stored as an **integer epoch-day** (days since 1970-01-01, computed in UTC) so no
UTC/DST conversion can shift a calendar day. A `Clock` (`LocalDate Function()`)
is injected — domain code never calls `DateTime.now()` directly.

## Recurrence (`RecurrenceCalculator`, pure)

Frequencies: `daily`, `weekly` (interval weeks + weekday set), `monthly`
(day-of-month **or** ordinal weekday), `yearly` (month+day), `customInterval`
(every N days). Rules honour `startDate`, `endDate`, `maxOccurrences`.

Date rules (tested):
- **Missing day of month** → clamp to the **last day** of that month (31 Jan,
  28/29 Feb, 30 Apr, …); never spill into the next month.
- **29 Feb yearly** → 29 Feb in leap years, otherwise 28 Feb.
- Ordinal weekday supports 1st…4th and **last**.

## Database (schema v3)

New tables: `recurring_rules`, `recurring_rule_weekdays` (join for weekly),
`recurring_occurrences` (UNIQUE `recurring_rule_id + original_due_date` to stop
duplicate generation). A new `app_settings.auto_create_recurring_enabled` column
(default false). `onUpgrade` handles v1→v3 and v2→v3; migration tests cover both.

## Generation

`RecurrenceGenerationService.generate(window)` is **idempotent, atomic and
re-runnable**: it computes due dates in `[windowStart, today+90d]` and inserts
occurrences with `insertOrIgnore` (the unique constraint blocks duplicates),
then advances `last_generated_through`. New rules backfill only ~60 days; a rule
last generated long ago backfills from there, so a long app absence produces the
right overdue occurrences. It runs on app open / when the Recurring screen opens
— **no background timer**.

## Occurrence status (mostly derived)

Stored status is one of `scheduled | paid | skipped | cancelled`. **due** and
**overdue** are computed from the effective due date (`snoozedUntil ?? dueDate`)
vs. today, and **paid** is only shown when the linked transaction still exists
and is not soft-deleted. This means deleting/restoring the posted transaction
reopens/re-pays the occurrence **reactively with no occurrence writes**.
(Documented decision.)

## Posting

"Mark paid/received" creates the transaction via the existing repository with the
correct `TransactionType`/semantic and links `generated_transaction_id`, marks
the occurrence `paid`, all in **one atomic DB transaction** with a double-post
guard. Edit-before-posting changes only that transaction, never the rule.

## Auto-create

Off by default (`auto_create_recurring_enabled`). When on and a rule opts in,
generation auto-posts each **due/overdue** occurrence **once**, never future
ones, never duplicates, never when the account/category is archived (leaves it
and raises an insight).

## Snooze / Skip / Pause / Resume / End / Edit

- **Snooze** sets `snoozed_until` (keeps `original_due_date`); affects one
  occurrence only.
- **Skip** marks one occurrence `skipped` (confirmation + optional reason).
- **Pause/Resume** stop/restart generation without deleting occurrences.
- **End** sets `is_active=false`/`end_date`; occurrences with paid history are
  never hard-deleted.
- **Edit rule** updates only **future unpaid** occurrences (paid/skipped
  untouched, past transactions untouched); a schedule change cancels future
  unpaid occurrences and regenerates — atomically.

## Budget & dashboard integration

Unpaid occurrences never enter `BudgetCalculator` (no actuals). They are surfaced
separately as *Upcoming Recurring* on the Budget screen/item details and in a
dashboard *Upcoming Bills* card — visually and numerically distinct from
Assigned/Actual. All reactive via Drift streams + Riverpod.

## Tests

Unit (recurrence math incl. day-31/leap-year/ordinal/interval/end/max/snooze/
status), database (v2→v3 & v1→latest migration, CRUD, validation, unique
occurrence, idempotent generation, long absence, atomic posting, double-post
rejection, skip/snooze/pause/resume, edit future, archived protection, FKs),
integration (post income/expense/liability updates dashboard/budget, unpaid ≠
balance, delete/restore reopen/repay, auto-create idempotency), widget (states,
create wizard validations, mark paid, snooze, skip, overdue, dashboard card).
