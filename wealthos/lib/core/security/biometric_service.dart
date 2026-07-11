import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import '../utils/app_logger.dart';

/// Handles the app-lock biometric setting and authentication.
///
/// The *enabled* flag is stored in [FlutterSecureStorage] (not the main
/// database) so the security preference lives in the platform keystore/keychain.
class BiometricService {
  BiometricService({LocalAuthentication? auth, FlutterSecureStorage? storage})
    : _auth = auth ?? LocalAuthentication(),
      _storage = storage ?? const FlutterSecureStorage();

  static const String _enabledKey = 'biometric_enabled';

  final LocalAuthentication _auth;
  final FlutterSecureStorage _storage;

  Future<bool> isEnabled() async {
    final value = await _storage.read(key: _enabledKey);
    return value == 'true';
  }

  Future<void> setEnabled({required bool enabled}) =>
      _storage.write(key: _enabledKey, value: enabled ? 'true' : 'false');

  /// Whether the device can actually perform biometric/device auth.
  Future<bool> canAuthenticate() async {
    try {
      return await _auth.isDeviceSupported() && await _auth.canCheckBiometrics;
    } on Exception catch (e) {
      AppLogger.error('biometric availability check failed', e);
      return false;
    }
  }

  /// Prompts the user to authenticate. Returns true on success.
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        persistAcrossBackgrounding: true,
      );
    } on Exception catch (e) {
      AppLogger.error('biometric authentication failed', e);
      return false;
    }
  }
}
