import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/api/notification_alert.dart';
import 'package:fyp/constants/size.dart';
import 'package:fyp/providers/user_doc_provider.dart';
import 'package:fyp/screens/Student/student_emergency_contacts.dart';
import 'package:fyp/reusable_widgets/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
          body: Column(
        children: const [
          AppBar(),
          Body(),
        ],
      )),
    );
  }
}

class Body extends ConsumerStatefulWidget {
  const Body({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  sendAlert(var username, {String? token}) async {
    int statusCodeTopic =
        await sendEmergencyAlert("$username is in need of emergency help!");
    if (token != null) {
      int statusCodeToken = await sendEmergencyAlert(
          "$username is in need of emergency help!",
          token: token);
      if (statusCodeToken == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Emergency alert to parents has been issued!"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 10), // defaults to 4 seconds
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ));
        }
      }
    }

    if (statusCodeTopic == 200) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Emergency alert to faculty has been issued!"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 10), // defaults to 4 seconds
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var studentRef = ref.watch(studentDocProvider);
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Container(
          margin: const EdgeInsets.all(2.0),
          //color: Colors.white,
          width: double.infinity,
          child: Text(
              style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 113, 85, 236)),
              '  Safety Services'),
        ),
        studentRef.when(
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
            error: (error, stackTrace) => const Center(
                child: Text("An error occured while fetching data...")),
            data: (msg) => Center(
                  child: Card(
                    elevation: 0,
                    shadowColor: Colors.black,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(25.0),
                    // ),
                    // color: Color.fromARGB(255, 113, 85, 236),
                    child: SizedBox(
                      width: double.infinity,
                      height: 212,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      sendAlert(msg.get('username'),
                                          token: msg.get("parentDeviceToken"));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff886ff2),
                                        border: Border.all(
                                          color: const Color(0xff6849ef),
                                          style: BorderStyle.solid,
                                          width: 3.0,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(.1),
                                            blurRadius: 4.0,
                                            spreadRadius: .05,
                                          ), //BoxShadow
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              "assets/images/alertwhite.png",
                                              height: kCategoryCardImageSize,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Trigger Help Alert",
                                            style: GoogleFonts.nunito(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
        Container(
          margin: const EdgeInsets.all(2.0),
          // color: Colors.white,
          width: double.infinity,
          child: Text(
              style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0B071D)),
              '  Student Safety Assist'),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EmergencyContactsScreen())),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromARGB(255, 245, 242, 242),
            ),
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/images/contact.png",
                    height: 50,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Emergency Contacts",
                        style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0B071D)),
                      ),
                      // Text(
                      //   "0 contacts added",
                      //   style: Theme.of(context).textTheme.bodySmall,
                      // ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                const Icon(Icons.navigate_next_outlined),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 120,
      // width: double.infinity,
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
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleButton(
                  icon: Icons.settings,
                  onPressed: () {},
                ),
                Text(
                  "Alert",
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
          ],
        ),
      ),
    );
  }
}
