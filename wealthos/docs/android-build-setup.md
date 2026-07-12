# Android Build Setup

WealthOS builds with the standard Flutter Android toolchain. The CI sandbox used
to author this branch has **no Android SDK** (and the SDK host is blocked by
network policy), so the APK/AAB builds must be run on a local machine with the
SDK installed. This document lists the exact requirements and commands.

## Requirements

| Tool | Version |
| --- | --- |
| Flutter | 3.44.6 (stable) — Dart 3.12.2 |
| JDK | 17 (the Gradle config targets `JavaVersion.VERSION_17`) |
| Android SDK | Platform + build-tools for the Flutter default `compileSdk`/`targetSdk` |
| Gradle | provided by the Gradle wrapper (`android/gradlew`) |
| NDK | the Flutter default `ndkVersion` (only if a plugin needs it) |

`compileSdk`, `targetSdk`, `minSdk`, `versionCode` and `versionName` are all
inherited from Flutter (`flutter.compileSdkVersion`, etc.) in
`android/app/build.gradle.kts`, so upgrading Flutter moves them together.

Application id / namespace: **`com.wealthos.wealthos`** (a real, publishable id —
not `com.example`). Display name: **WealthOS**.

## One-time setup

### macOS

```bash
# 1. Install Flutter (if not already) and add to PATH
#    https://docs.flutter.dev/get-started/install/macos
# 2. Install Android Studio, then its SDK + command-line tools.
# 3. Point Flutter at the SDK and accept licenses:
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"
flutter config --android-sdk "$ANDROID_HOME"
sdkmanager --licenses            # or: flutter doctor --android-licenses
brew install --cask temurin@17   # JDK 17 (or use Android Studio's bundled JDK)
export JAVA_HOME="$(/usr/libexec/java_home -v 17)"
flutter doctor -v                # expect Android toolchain ✓
```

### Windows (PowerShell)

```powershell
# 1. Install Flutter and Android Studio (with SDK + cmdline-tools).
# 2. Set environment variables (System > Environment Variables or per-session):
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
$env:Path += ";$env:ANDROID_HOME\platform-tools;$env:ANDROID_HOME\cmdline-tools\latest\bin"
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-17"   # adjust to your JDK 17
flutter config --android-sdk $env:ANDROID_HOME
flutter doctor --android-licenses
flutter doctor -v                # expect Android toolchain ✓
```

## Build commands (both platforms)

```bash
cd wealthos
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter build apk --debug           # debug APK (debug-signed)
flutter build apk --release         # release APK
flutter build appbundle --release   # Play Store AAB
```

Run on a device/emulator:

```bash
flutter devices
flutter run                          # debug
flutter run --release                # release (needs signing, see below)
```

## Release signing (no secrets in the repo)

Release signing is loaded from `android/key.properties`, which is **gitignored**
(along with `*.keystore` / `*.jks`). When the file is **absent**, the release
build falls back to the debug key so `flutter build apk --release` still runs —
but the artifact is **not** upload-ready.

To produce an upload-ready build:

```bash
# 1. Generate an upload keystore (keep it OUT of the repo):
keytool -genkey -v -keystore ~/wealthos-upload.jks -keyalg RSA -keysize 2048 \
  -validity 10000 -alias upload

# 2. Create android/key.properties (gitignored) with:
#    storePassword=...
#    keyPassword=...
#    keyAlias=upload
#    storeFile=/absolute/path/to/wealthos-upload.jks

# 3. Build:
flutter build appbundle --release
```

Never commit the keystore or `key.properties`. Store the keystore and passwords
in a secure secret manager / CI secret store.

## R8 / shrinking

R8 shrinking is **not** enabled by default to avoid stripping plugin classes on
an untested build. Before enabling `isMinifyEnabled`/`shrinkResources`, add the
appropriate ProGuard keep-rules and verify the release build on a device.
