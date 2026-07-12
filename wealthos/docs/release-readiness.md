# Release Readiness

Summary of WealthOS's readiness for an Android release after the Device QA &
Release-Readiness phase (schema **v5**).

## Ready

- **Code health**: `dart run build_runner build`, `dart format
  --set-exit-if-changed .`, `flutter analyze` (no issues), and `flutter test`
  (all green) pass in CI.
- **Data model**: migrations v1→v5 verified with real upgrade tests plus
  `PRAGMA foreign_key_check` / `integrity_check` and cross-feature invariant
  checks on a seeded database.
- **Data safety**: goal transfers are now a paired unit (`transfer_group_id`,
  schema v5) — deleting/restoring one leg moves both; the goal fund cache is
  reconciled with its ledger at startup and is verifiable/repairable.
- **Navigation**: 5-tab bottom bar (Dashboard, Budget, Goals, Accounts, More)
  keeps Arabic labels legible; Recurring and Settings live under **More** with
  full access preserved.
- **Security / privacy**: `FLAG_SECURE` privacy screen; `allowBackup=false` +
  data-extraction rules; no `INTERNET` permission (fully offline); no secrets in
  the repo; no sensitive logging.
- **Release config**: real application id `com.wealthos.wealthos`, label
  "WealthOS", JDK 17, SDK versions inherited from Flutter, conditional release
  signing from a gitignored `key.properties`.

## Requires a local Android SDK (Not Executed here)

The authoring sandbox has **no Android SDK** and the SDK host is blocked by
network policy, so these were **not run** (do not assume success):

- `flutter build apk --debug`, `flutter build apk --release`,
  `flutter build appbundle --release`.
- On-device smoke test (`device-smoke-test.md`), performance measurements, and
  device-only accessibility/biometric/privacy-screen checks.

Follow `android-build-setup.md` on macOS or Windows to run these.

## Before publishing to Play

1. Generate a real **upload keystore**; create `android/key.properties` (never
   committed). Build the AAB and verify it installs & runs on a device.
2. Decide on **R8/shrinking**: add ProGuard keep-rules and verify a shrunk
   release build on-device before enabling it.
3. Set the marketing **version** (`pubspec.yaml` `version:`), app icons and
   splash for production (placeholders ship today).
4. Run the full `qa-checklist.md` on real devices and record Pass/Fail.
5. Complete Play Console data-safety disclosures — WealthOS stores data locally
   only and requests no network access.

## Residual risks

- APK/AAB not built in this environment — build locally before release.
- R8 disabled by default (safer un-tested); enabling needs on-device
  verification.
- App icons / splash are template placeholders.
- Biometric gate and privacy screen are validated by code review only here;
  confirm on a physical device.
