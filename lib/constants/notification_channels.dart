import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel androidEmergencyChannel =
    AndroidNotificationChannel(
  'emergency_alerts', // id
  'High importance channel for emergency alerts', // title
  description:
      'This channel is used for important emergency alert notifications.', // description
  importance: Importance.max,
);
