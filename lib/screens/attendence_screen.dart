import 'package:fyp/reusable_widgets/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// class StudentAttendance extends StatefulWidget {
//   const StudentAttendance({Key? key}) : super(key: key);

//   @override
//   _StudentAttendanceState createState() => _StudentAttendanceState();
// }

// class _StudentAttendanceState extends State<StudentAttendance> {
//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         body: Column(
//           children: const [
//             AppBar(),
//             Body(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Body extends StatelessWidget {
//   const Body({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
//             child: Image(
//                 image: AssetImage("assets/images/attendence.png"),
//                 fit: BoxFit.cover),
//           ),
//         ],
//       ),
//     );
//   }
// }

class AppBar extends StatelessWidget {
  const AppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      height: 120,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5],
          colors: [
            Color(0xff886ff2),
            Color(0xff6849ef),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleButton(
                icon: Icons.settings,
                onPressed: () {},
              ),
              Text(
                "Attendence",
                style: GoogleFonts.nunito(
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
              CircleButton(
                icon: Icons.chat_rounded,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
