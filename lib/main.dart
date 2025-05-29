import 'package:chatt_app/core/dependencies/dependencies.dart';
import 'package:chatt_app/service/fcm_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';

void main() async {
  setup();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FCMService.initializeFCM();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      print('🔔 ${message.notification!.title}: ${message.notification!.body}');
    }
  });

  runApp(MyApp());
}
