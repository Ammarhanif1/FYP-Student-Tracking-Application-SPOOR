import 'package:fyp/constants/color.dart';
import 'package:fyp/constants/icons.dart';
import 'package:fyp/constants/size.dart';
import 'package:flutter/material.dart';

import '../Faculty/faculty_location_screen.dart';
import '../Faculty/faculty_course_screen.dart';

class FacultyPanel extends StatefulWidget {
  const FacultyPanel({Key? key}) : super(key: key);

  @override
  _FacultyPanelState createState() => _FacultyPanelState();
}

class _FacultyPanelState extends State<FacultyPanel> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    FacultyLocationScreen(),
    FacultyCourseScreen(),
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
                icCourse,
                height: kBottomNavigationBarItemSize,
              ),
              icon: Image.asset(
                icCourseOutlined,
                height: kBottomNavigationBarItemSize,
              ),
              label: "Course",
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
