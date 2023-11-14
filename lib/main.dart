import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/constants/notification_channels.dart';
import 'package:fyp/screens/splash.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  debugPrint("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ! THE SETUP RELATING TO FOREGROUND NOTIFICATIONS IN DONE IN [latselection.dart]
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidEmergencyChannel);

  await Hive.initFlutter();
  await Hive.openBox('emergencyContacts');

  runApp(const ProviderScope(
    child: MaterialApp(
      home: SplashPage(),
      // home: RegistrationScreen(),
      // home: LoginScreen(),
    ),
  ));
}
