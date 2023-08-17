import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings initializationIos =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationIos);
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  Future<void> simpleNotificationShow(
      {required String heading,
      required String detail,
      required int hashCode}) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('Channel_id', 'Channel_title',
            priority: Priority.high,
            importance: Importance.max,
            icon: '@mipmap/ic_launcher',
            channelShowBadge: true,
            largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'));

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await notificationsPlugin.show(
        hashCode, heading, detail, notificationDetails);
  }

  Future<void> bigPictureNotificationShow() async {
    BigPictureStyleInformation bigPictureStyleInformation =
        const BigPictureStyleInformation(
            DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
            contentTitle: 'Code Compilee',
            largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'));

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('big_picture_id', 'big_picture_title',
            priority: Priority.high,
            importance: Importance.max,
            styleInformation: bigPictureStyleInformation);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await notificationsPlugin.show(
        1, 'Big Picture Notification', 'New Message', notificationDetails);
  }

  Future<void> multipleNotificationShow() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('Channel_id', 'Channel_title',
            priority: Priority.high,
            importance: Importance.max,
            groupKey: 'commonMessage');

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    notificationsPlugin.show(
        0, 'New Notification', 'User 1 send message', notificationDetails);

    Future.delayed(
      const Duration(milliseconds: 1000),
      () {
        notificationsPlugin.show(
            1, 'New Notification', 'User 2 send message', notificationDetails);
      },
    );

    Future.delayed(
      const Duration(milliseconds: 1500),
      () {
        notificationsPlugin.show(
            2, 'New Notification', 'User 3 send message', notificationDetails);
      },
    );

    List<String> lines = ['user1', 'user2', 'user3'];

    InboxStyleInformation inboxStyleInformation = InboxStyleInformation(lines,
        contentTitle: '${lines.length} messages', summaryText: 'Code Compilee');

    AndroidNotificationDetails androidNotificationSpesific =
        AndroidNotificationDetails('groupChennelId', 'groupChennelTitle',
            styleInformation: inboxStyleInformation,
            groupKey: 'commonMessage',
            setAsGroupSummary: true);
    NotificationDetails platformChannelSpe =
        NotificationDetails(android: androidNotificationSpesific);
    await notificationsPlugin.show(
        3, 'Attention', '${lines.length} messages', platformChannelSpe);
  }
}
