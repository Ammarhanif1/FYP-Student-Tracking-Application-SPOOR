import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/constants/color.dart';
import 'package:fyp/constants/icons.dart';
import 'package:fyp/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/Parent/parent_student_attendance.dart';
import 'package:fyp/screens/Parent/parent_student_location.dart';
import 'package:fyp/screens/Parent/parent_student_selection.dart';
import 'package:fyp/screens/schedule_screen.dart';

import '../../providers/user_doc_provider.dart';

class ParentPanel extends ConsumerStatefulWidget {
  const ParentPanel({Key? key}) : super(key: key);

  @override
  _ParentPanelState createState() => _ParentPanelState();
}

class _ParentPanelState extends ConsumerState<ParentPanel> {
  int _selectedIndex = 0;

  updateDeviceToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    var db = FirebaseFirestore.instance;
    ref.read(parentDocProvider.future).then((parentDoc) async {
      var childUID = parentDoc.get('childID');
      if (childUID == null || childUID == "") return;

      await db
          .collection('students')
          .doc(childUID)
          .update({'parentDeviceToken': fcmToken});
      debugPrint("Updated student $childUID with parentDeviceToken $fcmToken");
    });
  }

  @override
  void initState() {
    super.initState();
    updateDeviceToken();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    ScheduleScreen(),
    ParentAttendance(),
    ParentStudentLocation(),
  ];
  @override
  Widget build(BuildContext context) {
    var parentRef = ref.watch(parentDocProvider);

    return parentRef.when(
        data: (data) {
          if (data.get('childID') == null || data.get('childID') == "") {
            return const ParentStudentSelection();
          }
          return Scaffold(
            body: _widgetOptions.elementAt(_selectedIndex),
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
                      icAttendence,
                      height: kBottomNavigationBarItemSize,
                    ),
                    icon: Image.asset(
                      icAttendenceOutline,
                      height: kBottomNavigationBarItemSize,
                    ),
                    label: "Attendance",
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
                ],
                currentIndex: _selectedIndex,
                onTap: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          );
        },
        error: (error, stackTrace) =>
            const Text("Error while fetching data..."),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }
}
