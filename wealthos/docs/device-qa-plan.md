# Device QA & Release-Readiness Plan

The plan for verifying that WealthOS is buildable, runnable and usable on real
Android devices after the schema reached **v5**. It defines environments,
devices, scenarios, data/RTL/performance/build tests, and the risks.

## 1. Test environments

| Environment | Purpose | Status in this repo |
| --- | --- | --- |
| CI sandbox (Linux, no Android SDK) | code build_runner / format / analyze / test | **Available** — all executed. |
| Local macOS + Android SDK + emulator/device | APK/AAB builds, on-device smoke | **Required** — see `android-build-setup.md`. |
| Local Windows + Android SDK + device | second build platform | **Required** — see `android-build-setup.md`. |

> The sandbox that produced this branch has **no Android SDK** and the SDK
> download host is blocked by network policy, so `flutter build apk/appbundle`
> and on-device steps are **Not Executed** here. Every code-level check that
> does not need the SDK was run. `flutter doctor -v` output and exact
> requirements are captured in `android-build-setup.md`.

## 2. Devices & sizes

Representative matrix (logical pixels):

| Class | Size | Notes |
| --- | --- | --- |
| Small phone | 320×568 | tightest width; nav-label + overflow risk |
| Common phone | 360×640 | baseline |
| Modern phone | 390×844 | notch/safe-area |
| Large phone | 412×915 | |
| Tablet | 800×1280 | wide layout, landscape |

Each screen is exercised in **ar (RTL)** and **en (LTR)**, **light** and
**dark**, and at **textScale 1.0 / 1.3 / 1.5 / 2.0**.

## 3. Usage scenarios

The full new-user journey (onboarding → accounts → transactions → budget →
recurring → goals → restart → biometric → locale/theme) is scripted in
`device-smoke-test.md` (25 steps). Feature-level cases are enumerated in
`qa-checklist.md`.

## 4. Data tests

- Real migrations **v1→v5, v2→v5, v3→v5, v4→v5** and a fresh v5 install.
- `PRAGMA foreign_key_check` and `PRAGMA integrity_check` on a fully-seeded DB.
- Cross-feature invariants: goal fund cache == ledger; no paid occurrence
  without a live transaction; no transaction over-allocated to goals; no budget
  item linked to a missing goal; both legs of a goal transfer consistent.
- These are automated in `test/database/integrity_test.dart`,
  `test/database/goals_test.dart`, `test/database/budget_test.dart`,
  `test/database/recurring_test.dart` and `test/database/database_test.dart`.

## 5. RTL tests

- Arabic labels across the 5-tab bottom bar + More menu.
- RTL reading order, mirrored icons where meaningful, and no clipped Arabic
  labels at large text scales (`test/widget/qa_test.dart`).

## 6. Performance tests (device)

Seed a large dataset (≈50 accounts, 10k transactions, 24 budgets, 300 items,
100 recurring rules, 2k occurrences, 100 goals, 2k fund entries) and measure
cold start, Dashboard, transaction list, budget/recurring/goals screens, and
Drift stream update latency. These are **device** measurements — Not Executed
in the sandbox; the plan and thresholds are in `qa-checklist.md` → Performance.
Streams already filter/limit at the query layer (e.g. dashboard recent = 5,
`watchAll({limit})`), so no widget loads thousands of rows at once.

## 7. Build tests

`flutter clean` → `pub get` → `build_runner build` → `analyze` → `test` →
`build apk --debug` → `build apk --release` → `build appbundle --release`.
The SDK-free steps are executed in CI; the APK/AAB steps require a local
Android SDK (documented). Release signing loads from a **gitignored**
`android/key.properties`; with no key file, release falls back to the debug key
so the build still runs but is **not** upload-ready.

## 8. Risks & results

| Risk | Mitigation | Result |
| --- | --- | --- |
| 6-tab bottom bar clipped in Arabic / large text | Restructured to 5 tabs + **More** (Recurring, Settings) | Fixed |
| One leg of a goal transfer deleted alone → funds diverge | `transfer_group_id`; delete/restore act on the whole group (schema v5) | Fixed + tested |
| Goal fund cache drifts from the ledger | `verifyFunds` + `repairAllFunds` + startup reconcile + integrity test | Fixed + tested |
| Overflow at 2.0 text scale on goal card / summary | `Wrap` instead of `Row` for money/pills | Fixed + tested |
| Financial data in recents / screenshots | `FLAG_SECURE` privacy screen | Fixed |
| Cloud/device backup of the local DB | `allowBackup=false` + data-extraction rules | Fixed |
| APK/AAB not built here | Documented setup; run locally with the Android SDK | Not Executed (SDK unavailable) |
