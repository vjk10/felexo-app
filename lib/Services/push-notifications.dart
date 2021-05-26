import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "curated_channel",
    "Curated Channel",
    "This Channel is used for Curated Notification");

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> fcmBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("FCM INITIALIZED: ${message.messageId}");
  print("FCM MESSAGE DATA: ${message.data}");
}

class PushNotificationService {
  initialize() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_f');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      RemoteNotification remoteNotification = remoteMessage.notification;
      AndroidNotification androidNotification =
          remoteMessage.notification?.android;
      if (remoteNotification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
            remoteNotification.hashCode,
            remoteNotification.title,
            remoteNotification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    enableVibration: true,
                    priority: Priority.high,
                    channelShowBadge: true,
                    icon: androidNotification?.smallIcon)));
      }
    });
  }

  Future<String> getToken() async {
    String tokenFcm = await FirebaseMessaging.instance.getToken();
    print("FCM TOKEN: " + tokenFcm);
    return tokenFcm;
  }

  subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }
}
