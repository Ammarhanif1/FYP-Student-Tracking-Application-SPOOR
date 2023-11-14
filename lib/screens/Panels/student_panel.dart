import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/constants/color.dart';
import 'package:fyp/constants/icons.dart';
import 'package:fyp/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/Student/student_attendance.dart';
import 'package:fyp/screens/schedule_screen.dart';
import 'package:fyp/screens/alert_screen.dart';
import 'package:fyp/screens/Student/student_location_screen.dart';
import 'package:geolocator/geolocator.dart';

import '../../providers/user_doc_provider.dart';

class StudentPanel extends ConsumerStatefulWidget {
  const StudentPanel({Key? key}) : super(key: key);

  @override
  _StudentPanelState createState() => _StudentPanelState();
}

class _StudentPanelState extends ConsumerState<StudentPanel> {
  int _selectedIndex = 0;
  StreamSubscription<Position>? positionStream;

  startLocationSync() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("Error: Location Services Disabled!!");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("Error: Location Permission denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint("Error: Location Permissions denied forever");
      return;
    }

    // As long as the student is in the app and moves ~100 meters, thei
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 100,
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((currentLocation) async {
      await ref.read(studentDocProvider).value?.reference.set({
        "lastLocation":
            GeoPoint(currentLocation.latitude, currentLocation.longitude)
      }, SetOptions(merge: true));
    });
  }

  @override
  void initState() {
    startLocationSync();
    super.initState();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    ScheduleScreen(),
    StudentLocationScreen(),
    StudentAttendance(),
    AlertScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kPrimaryColor,
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                icSchedule,
                height: kBottomNavigationBarItemSize,
              ),
              icon: Image.asset(
                icScheduleOutlined,
                height: kBottomNavigationBarItemSize,
              ),
              label: "Schedule",
            ),
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                icLocation,
                height: kBottomNavigationBarItemSize,
              ),
              icon: Image.asset(
                icLocationOutlined,
                height: kBottomNavigationBarItemSize,
              ),
              label: "Location",
            ),
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                icAttendence,
                height: kBottomNavigationBarItemSize,
              ),
              icon: Image.asset(
                icAttendenceOutline,
                height: kBottomNavigationBarItemSize,
              ),
              label: "Attendence",
            ),
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                icAlert,
                height: kBottomNavigationBarItemSize,
              ),
              icon: Image.asset(
                icAlertOutlined,
                height: kBottomNavigationBarItemSize,
              ),
              label: "Alert",
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          }),
    );
  }
}
