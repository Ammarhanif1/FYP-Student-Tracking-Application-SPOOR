// ! NOTE: while this will work for a prototype app such as this, this is NOT
// ! secure at all. Please use Firebase Admin SDK when you can afford to use a
// ! server to host that SDK.

import 'dart:convert';

import 'package:http/http.dart' as http;

const String fcmApiUrl = "https://fcm.googleapis.com/fcm/send";
const String serverKey =
    "key=AAAA38-Td9w:APA91bElQpuenlKbXvg4YxIhbHkyjAiWhCQGPYnaD_8PMXfnAp-ixSKdNpXP_1-k6OqtviMZCL-B54TVNx3d5uCKRDZssNyuqCr84O6mTaR0gJsOD_CrDpn36aZo514TUMUsTdOGFbPh";

// Emergency alert will be sent to token if not null
Future<int> sendEmergencyAlert(String body, {String? token}) async {
  var response = await http.post(Uri.parse(fcmApiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': serverKey,
      },
      body: jsonEncode({
        "notification": {
          "android_channel_id": "emergency_alerts",
          "title": "Emergency Alert",
          "body": body,
          "priority": "high"
        },
        "to": token ?? "/topics/emergencyAlert"
      }));

  return response.statusCode;
}
