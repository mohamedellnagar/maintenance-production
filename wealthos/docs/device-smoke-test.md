# Device Smoke Test — New User Journey

The full first-run journey to run on a real device / emulator. Every step lists
its **Expected result**. Because the authoring sandbox has **no Android SDK**,
the on-device **Status is `Not Executed — Android SDK/device unavailable`**;
where an automated test already covers the underlying behaviour it is noted.
Run this list on a device after `flutter run` (see `android-build-setup.md`).

| # | Step | Expected result | Status |
| --- | --- | --- | --- |
| 1 | First launch | Onboarding shows; app is pinned to `/onboarding` until completed | Not Executed (device) — logic in `test/widget/onboarding_test.dart` |
| 2 | Choose Arabic | UI flips to RTL, Arabic strings everywhere | Not Executed (device) — RTL in `test/widget/qa_test.dart` |
| 3 | Choose AED | Base currency set to AED; amounts format with د.إ | Not Executed (device) |
| 4 | Create a bank account | Account saved, appears in Accounts; net worth updates | Not Executed (device) — repo in `database_test.dart` |
| 5 | Create a cash account | Second asset account saved | Not Executed (device) |
| 6 | Create a credit card | Liability account saved; shows outstanding as positive | Not Executed (device) — `accounting_model_test.dart` |
| 7 | Record income | Bank balance + monthly income rise | Not Executed (device) |
| 8 | Record an expense | Bank balance + monthly expense change | Not Executed (device) |
| 9 | Record a card purchase | Card debt increases (liability charge, not asset expense) | Not Executed (device) — `accounting_model_test.dart` |
| 10 | Record a card repayment | Bank down, card debt down; not double-counted as expense | Not Executed (device) — `accounting_model_test.dart` |
| 11 | Create this month's budget | Budget screen shows KPIs | Not Executed (device) — `budget_test.dart` |
| 12 | Add an expense item | Item appears; actual vs plan tracked | Not Executed (device) — `budget_reactive_test.dart` |
| 13 | Create a recurring salary | Rule created; upcoming income planned | Not Executed (device) — `recurring_test.dart` |
| 14 | Create a recurring bill | Rule created; Upcoming Bills card populates | Not Executed (device) — `recurring_test.dart` |
| 15 | Post a due occurrence | Real transaction created + linked; occurrence paid | Not Executed (device) — `recurring_test.dart` |
| 16 | Create a financial goal | Goal appears with a zero fund | Not Executed (device) — `goals_test.dart` |
| 17 | Allocate to the goal | Fund rises; no transaction; allocated/unallocated update | Not Executed (device) — `goals_reactive_test.dart` |
| 18 | Withdraw from the goal | Fund drops; no income created; bounded by balance | Not Executed (device) — `goals_test.dart` |
| 19 | Transfer between two goals | Total allocated unchanged; both legs recorded | Not Executed (device) — `goals_test.dart` |
| 20 | Close & reopen the app | App relaunches to Dashboard | Not Executed (device) |
| 21 | Verify data persisted | Accounts, transactions, budget, rules, goals, funds all present | Not Executed (device) — `test/integration/persistence_test.dart` |
| 22 | Enable biometric, reopen | App-lock gate requires auth before content | Not Executed (device) — gate in `AppLockGate` |
| 23 | Switch language to English | UI flips to LTR, English strings | Not Executed (device) — `qa_test.dart` (both locales) |
| 24 | Toggle light/dark | Theme switches; content legible in both | Not Executed (device) — `qa_test.dart` dark smoke |
| 25 | Switch back to Arabic | UI returns to RTL Arabic, no data change | Not Executed (device) |

## Additional device observations to record

- Cold-start time and jank on the seeded large dataset (see `qa-checklist.md`).
- App-switcher/recents shows a blank/secure surface (FLAG_SECURE).
- Keyboard does not cover the active input in any form; numeric keyboards for
  amounts; Arabic-Indic and ASCII digits both accepted.
- No RenderFlex overflow at 320 px width and 2.0 text scale.

When executed on a device, replace each **Status** with Pass/Fail + notes.
