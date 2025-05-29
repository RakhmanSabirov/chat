import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp();
    await _setupFlutterLocalNotifications();
    await _requestPermissions();
    _handleForegroundMessages();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    _logToken();
  }

  static Future<void> _setupFlutterLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotificationsPlugin.initialize(initSettings);
  }

  static Future<void> _requestPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('🔔 Notification permission: ${settings.authorizationStatus}');
  }

  static void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📥 Foreground message received: ${message.messageId}');
      _showNotification(message);
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    debugPrint('🔙 Background message: ${message.messageId}');
  }

  static void _showNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      _localNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'Default Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  }

  static Future<void> _logToken() async {
    final token = await _messaging.getToken();
    debugPrint('🔥 FCM Token: $token');
    // Можно сохранить токен в Firestore или отправить на сервер
  }
}
