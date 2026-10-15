import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _notificationsPlugin.initialize(settings: initSettings);

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      try {
        await androidImplementation.requestExactAlarmsPermission();
      } catch (_) {}
    }
  }

  // Anlık Bildirim
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'eterna_habit_channel',
      'Alışkanlık Hatırlatıcıları',
      channelDescription:
          'Tamamlanmayan alışkanlıklar için hatırlatma bildirimleri',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }

  // Arka Planda Zamanlanmış Bildirim
  Future<void> scheduleRepeatedNotification({
    required int id,
    required String title,
    required String body,
    required int seconds,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'eterna_habit_channel',
      'Alışkanlık Hatırlatıcıları',
      channelDescription:
          'Tamamlanmayan alışkanlıklar için hatırlatma bildirimleri',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    final scheduledTime = tz.TZDateTime.now(tz.local)
        .add(Duration(seconds: seconds < 5 ? 5 : seconds));

    try {
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledTime,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (_) {
      // Hassas alarm yetkisi sistem kısıtına takılırsa inexact moduna düşer
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledTime,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }
}
