import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  static const _serverKey = 'YOUR_FIREBASE_SERVER_KEY';

  static Future<void> sendPushNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$_serverKey',
      },
      body: jsonEncode({
        'to': token,
        'notification': {'title': title, 'body': body, 'sound': 'default'},
        'priority': 'high',
      }),
    );

    if (response.statusCode != 200) {
      print('❌ Push error: \${response.body}');
    } else {
      print('✅ Push sent to \$token');
    }
  }
}
