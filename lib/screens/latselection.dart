import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp/screens/Panels/faculty_panel.dart';
import 'package:fyp/screens/Panels/parent_panel.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/notification_channels.dart';
import '../models/user_models.dart';
import 'Panels/student_panel.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage(this.uid, this.username, {super.key});

  /// This data can be queried from FirebaseAuth
  final String uid;
  final String username;

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  var loading = true;
  validateRole() async {
    var db = FirebaseFirestore.instance;
    // Maybe find a better way to do this?
    // User is student
    var userRef = await db.collection("students").doc(widget.uid).get();
    if (userRef.exists) {
      if (mounted) {
        unsubscribeToEmergencyAlerts();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const StudentPanel()));
      }
    }

    // User is a parent
    userRef = await db.collection("parents").doc(widget.uid).get();
    if (userRef.exists) {
      if (mounted) {
        unsubscribeToEmergencyAlerts();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ParentPanel()));
      }
    }

    // user is a faculty
    userRef = await db.collection("faculty").doc(widget.uid).get();
    if (userRef.exists) {
      if (mounted) {
        subscribeToEmergencyAlerts();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const FacultyPanel()));
      }
    }

    // if user does not exist in any collection, then stop loading and show
    // selection page.
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  setupNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    debugPrint(
        'Notification Permission Status: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = notification?.android;
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                android.channelId ?? "miscellaneous",
                android.channelId == androidEmergencyChannel.id
                    ? androidEmergencyChannel.name
                    : "Miscellaneous",
                styleInformation: BigTextStyleInformation(
                    notification.body ?? "",
                    contentTitle: notification.title),
                channelDescription:
                    android.channelId == androidEmergencyChannel.id
                        ? androidEmergencyChannel.description
                        : "Miscellaneous channel",
                icon: "@mipmap/ic_launcher",
              ),
            ));
      }
    });
  }

  @override
  void initState() {
    setupNotifications();
    validateRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 30.0)),
                  Text(
                      style: GoogleFonts.nunito(
                        fontSize: 75,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5C5CFF),
                        decoration: TextDecoration.none,
                      ),
                      '...'),
                ],
              ),
              Row(
                children: [
                  // Padding(padding: EdgeInsets.only(left: 25.0)),
                  Text(
                      style: GoogleFonts.nunito(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        decoration: TextDecoration.none,
                      ),
                      'Hello there!'),
                  const SizedBox(
                    width: 75,
                  ),
                  const ImageIcon(
                    AssetImage("assets/images/onlylogo.png"),
                    color: Color(0xFF5C5CFF),
                    size: 70,
                  ),
                ],
              ),
              const Divider(
                color: Color(0xFF5C5CFF),
                height: 10,
                thickness: 4,
                indent: 60,
                endIndent: 220,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                  style: GoogleFonts.nunito(
                    fontSize: 35,
                    color: const Color(0xff868686),
                    decoration: TextDecoration.none,
                  ),
                  'Who Are You?'),
              Center(
                child: Column(
                  children: [
                    Card(
                      elevation: 15,
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      color: const Color(0xFFfce7ee),
                      child: SizedBox(
                        width: 300,
                        height: 230,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 40, 0, 0),
                          child: Row(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                flex: 40,
                                child: Center(
                                    child: Column(
                                  children: [
                                    Text(
                                        style: GoogleFonts.nunito(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold),
                                        'I am a Student'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: 90,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setStudentRole();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shadowColor: Colors.red,
                                            elevation: 8,
                                            backgroundColor:
                                                const Color(0xff5c5cff)),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              1.5, 1.5, 0.25, 1.5),
                                          child: Row(
                                            children: const [
                                              Text('Start'),
                                              Icon(Icons.play_arrow)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                              Expanded(
                                flex: 60,
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/students.png',
                                    width: 120,
                                    height: 120,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 15,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          color: const Color(0xFFe2f7f2),
                          child: SizedBox(
                            width: 140,
                            height: 180,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // ImageIcon(
                                //   AssetImage("assets/images/teacher.png"),
                                //   size: 40,

                                // ),
                                const Image(
                                  image:
                                      AssetImage("assets/images/teacher.png"),
                                  width: 60,
                                  height: 60,
                                  color: null,
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.center,
                                ),
                                const SizedBox(
                                  height: 10,
                                ), //SizedBox
                                Text(
                                    style: GoogleFonts.nunito(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                    'I am Faculty'),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: 90,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setFacultyRole();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shadowColor: Colors.green,
                                        elevation: 8,
                                        backgroundColor:
                                            const Color(0xff5c5cff)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.5),
                                      child: Row(
                                        children: const [
                                          Text('Start'),
                                          Icon(Icons.play_arrow)
                                        ],
                                      ),
                                    ),
                                  ),
                                ), //SizedBox
                              ],
                            ), //Padding
                          ), //SizedBox
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Card(
                          elevation: 15,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          color: const Color(0xFFfceed6),
                          child: SizedBox(
                            width: 140,
                            height: 180,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // ImageIcon(
                                //   AssetImage(
                                //     "assets/images/parents.png",
                                //   ),
                                //   size: 40,
                                // ),
                                const Image(
                                  image:
                                      AssetImage("assets/images/parents.png"),
                                  width: 60,
                                  height: 60,
                                  color: null,
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.center,
                                ),
                                const SizedBox(
                                  height: 10,
                                ), //SizedBox
                                Text(
                                    style: GoogleFonts.nunito(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                    'I am a Parent'),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: 90,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setParentRole();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shadowColor: Colors.yellow,
                                        elevation: 8,
                                        backgroundColor:
                                            const Color(0xff5c5cff)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.5),
                                      child: Row(
                                        children: const [
                                          Text('Start'),
                                          Icon(Icons.play_arrow)
                                        ],
                                      ),
                                    ),
                                  ),
                                ), //SizedBox
                              ],
                            ), //Padding
                          ), //SizedBox
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                  style: GoogleFonts.nunito(
                    fontSize: 35,
                    color: const Color(0xff868686),
                    decoration: TextDecoration.none,
                  ),
                  "Let's Get Started!"),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                color: Colors.yellow,
                height: 10,
                thickness: 4,
                indent: 75,
                endIndent: 90,
              ),
            ],
          );
  }

  void setStudentRole() async {
    setState(() {
      loading = true;
    });
    var db = FirebaseFirestore.instance;
    await db
        .collection("students")
        .doc(widget.uid)
        .set((Student()..username = widget.username).toMap())
        .then((value) {
      unsubscribeToEmergencyAlerts();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const StudentPanel()));
    });
  }

  void setParentRole() async {
    setState(() {
      loading = true;
    });
    var db = FirebaseFirestore.instance;
    await db
        .collection("parents")
        .doc(widget.uid)
        .set(Parent().toMap())
        .then((value) {
      unsubscribeToEmergencyAlerts();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ParentPanel()));
    });
  }

  void setFacultyRole() async {
    setState(() {
      loading = true;
    });
    var db = FirebaseFirestore.instance;
    await db
        .collection("faculty")
        .doc(widget.uid)
        .set({"exists": true}).then((value) {
      subscribeToEmergencyAlerts();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const FacultyPanel()));
    });
  }

  void subscribeToEmergencyAlerts() async {
    await FirebaseMessaging.instance.subscribeToTopic("emergencyAlert");
  }

  void unsubscribeToEmergencyAlerts() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic("emergencyAlert");
  }
}
