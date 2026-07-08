import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// خدمة الإشعارات المحلية (Offline) — تجدولة تنبيهات النظام لكل تذكير.
///
/// لا تتصل بالشبكة إطلاقًا؛ تعتمد على AlarmManager/النظام فقط.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const _channelId = 'wealthos_reminders';
  static const _channelName = 'تنبيهات WealthOS';

  Future<void> init() async {
    tzdata.initializeTimeZones();
    try {
      final name = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(name));
    } catch (_) {
      // في حال تعذّر تحديد المنطقة الزمنية نبقى على الافتراضي (UTC).
    }

    const androidInit = AndroidInitializationSettings('@drawable/ic_stat_notify');
    const settings = InitializationSettings(android: androidInit);
    await _plugin.initialize(settings);
    _ready = true;
  }

  /// طلب أذونات الإشعارات (أندرويد 13+).
  Future<void> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
  }

  /// جدولة تنبيه في وقت محدّد. يتجاهل المواعيد الماضية.
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime when,
  }) async {
    if (!_ready) return;
    final target = tz.TZDateTime.from(when, tz.local);
    if (target.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      target,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: 'تذكيرات الأقساط والمراجعات المالية',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      // وضع غير دقيق لتفادي الحاجة لإذن SCHEDULE_EXACT_ALARM.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancel(int id) async {
    if (!_ready) return;
    await _plugin.cancel(id);
  }
}
