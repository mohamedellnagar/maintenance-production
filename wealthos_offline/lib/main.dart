import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app.dart';
import 'core/security/encryption_service.dart';
import 'providers/providers.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // على أنظمة سطح المكتب نستخدم sqflite_common_ffi (لا يؤثر على أندرويد/iOS).
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // تهيئة خدمة التشفير (مفتاح AES محلي) قبل تشغيل الواجهة.
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  final encryption = EncryptionService(storage);
  await encryption.init();

  // تهيئة خدمة الإشعارات المحلية (بدون شبكة).
  final notifications = NotificationService();
  await notifications.init();
  await notifications.requestPermissions();

  runApp(
    ProviderScope(
      overrides: [
        secureStorageProvider.overrideWithValue(storage),
        encryptionServiceProvider.overrideWithValue(encryption),
        notificationServiceProvider.overrideWithValue(notifications),
      ],
      child: const WealthOSApp(),
    ),
  );
}
