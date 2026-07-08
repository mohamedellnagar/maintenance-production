import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// خدمة أمان فتح التطبيق: رمز PIN (مُجزّأ) + البصمة (Biometric).
class PinService {
  PinService(this._storage);

  final FlutterSecureStorage _storage;
  final LocalAuthentication _localAuth = LocalAuthentication();

  static const _pinKey = 'wealthos_pin_hash';
  static const _saltKey = 'wealthos_pin_salt';

  Future<bool> hasPin() async => (await _storage.read(key: _pinKey)) != null;

  Future<void> setPin(String pin) async {
    final salt = DateTime.now().microsecondsSinceEpoch.toString();
    await _storage.write(key: _saltKey, value: salt);
    await _storage.write(key: _pinKey, value: _hash(pin, salt));
  }

  Future<bool> verifyPin(String pin) async {
    final salt = await _storage.read(key: _saltKey);
    final stored = await _storage.read(key: _pinKey);
    if (salt == null || stored == null) return false;
    return _hash(pin, salt) == stored;
  }

  Future<void> clearPin() async {
    await _storage.delete(key: _pinKey);
    await _storage.delete(key: _saltKey);
  }

  String _hash(String pin, String salt) {
    final digest = sha256.convert(utf8.encode('$salt::$pin'));
    return digest.toString();
  }

  /// هل يدعم الجهاز مصادقة بيومترية؟
  Future<bool> canUseBiometrics() async {
    try {
      final supported = await _localAuth.isDeviceSupported();
      final canCheck = await _localAuth.canCheckBiometrics;
      return supported && canCheck;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticateBiometric(String reason) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
