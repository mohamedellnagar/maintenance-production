import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// خدمة تشفير الحقول الحساسة (AES-256) والمفاتيح.
///
/// المفتاح يُولَّد مرة واحدة ويُخزَّن في flutter_secure_storage (Keystore على
/// أندرويد)، ولا يغادر الجهاز إطلاقًا. تُستخدم لتشفير الملاحظات والقيم الحساسة،
/// ولتشفير ملف النسخ الاحتياطي بكلمة مرور المستخدم.
class EncryptionService {
  EncryptionService(this._storage);

  final FlutterSecureStorage _storage;
  static const _keyName = 'wealthos_aes_key';
  static const _prefix = 'enc::';

  enc.Encrypter? _encrypter;

  Future<void> init() async {
    var stored = await _storage.read(key: _keyName);
    if (stored == null) {
      stored = _generateKeyBase64();
      await _storage.write(key: _keyName, value: stored);
    }
    _encrypter = enc.Encrypter(
      enc.AES(enc.Key.fromBase64(stored), mode: enc.AESMode.cbc),
    );
  }

  String _generateKeyBase64() {
    final rnd = Random.secure();
    final bytes = Uint8List.fromList(
      List<int>.generate(32, (_) => rnd.nextInt(256)),
    );
    return base64Encode(bytes);
  }

  bool get _ready => _encrypter != null;

  /// تشفير نص. يعيد النص كما هو إن كان فارغًا أو الخدمة غير جاهزة.
  String encryptText(String? plain) {
    if (plain == null || plain.isEmpty || !_ready) return plain ?? '';
    final iv = enc.IV.fromSecureRandom(16);
    final encrypted = _encrypter!.encrypt(plain, iv: iv);
    return '$_prefix${iv.base64}:${encrypted.base64}';
  }

  /// فكّ تشفير نص مشفّر بصيغة enc::iv:cipher. يعيد النص كما هو إن لم يكن مشفّرًا.
  String decryptText(String? value) {
    if (value == null || value.isEmpty || !_ready) return value ?? '';
    if (!value.startsWith(_prefix)) return value; // نص غير مشفّر (توافقية).
    try {
      final body = value.substring(_prefix.length);
      final parts = body.split(':');
      if (parts.length != 2) return value;
      final iv = enc.IV.fromBase64(parts[0]);
      return _encrypter!.decrypt64(parts[1], iv: iv);
    } catch (_) {
      return value;
    }
  }

  /// تشفير حمولة كاملة (نص JSON) للنسخ الاحتياطي بكلمة مرور المستخدم.
  String encryptWithPassword(String plain, String password) {
    final encrypter = _passwordEncrypter(password);
    final iv = enc.IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(plain, iv: iv);
    return jsonEncode({'iv': iv.base64, 'data': encrypted.base64, 'v': 1});
  }

  String decryptWithPassword(String payload, String password) {
    final map = jsonDecode(payload) as Map<String, dynamic>;
    final encrypter = _passwordEncrypter(password);
    final iv = enc.IV.fromBase64(map['iv'] as String);
    return encrypter.decrypt64(map['data'] as String, iv: iv);
  }

  /// اشتقاق مفتاح 256-bit من كلمة مرور باستخدام SHA-256.
  enc.Encrypter _passwordEncrypter(String password) {
    final digest = sha256.convert(utf8.encode('wealthos::$password'));
    final key = enc.Key(Uint8List.fromList(digest.bytes));
    return enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  }
}
