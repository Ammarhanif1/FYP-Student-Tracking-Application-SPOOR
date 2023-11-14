import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/constants/size.dart';
import 'package:fyp/models/category.dart';
import 'package:fyp/providers/auth_provider.dart';
import 'package:fyp/providers/user_doc_provider.dart';
import 'package:fyp/screens/Student/student_daily_screen.dart';
import 'package:fyp/screens/auth/auth_check.dart';
import 'package:fyp/reusable_widgets/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

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
        ),
      ),
    );
  }
}

class Body extends ConsumerStatefulWidget {
  const Body({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 40,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1.8,
            crossAxisSpacing: 30,
            mainAxisSpacing: 35,
          ),
          itemBuilder: (context, index) {
            return CategoryCard(
              category: categoryList[index],
            );
          },
          itemCount: categoryList.length,
        ),
        ElevatedButton(
            onPressed: () {
              signOutUser(context, ref);
            },
            child: const Text("Sign out user"))
      ],
    );
  }

  void signOutUser(BuildContext context, WidgetRef ref) async {
    // await FirebaseAuth.instance.signOut(); // -> replacement if needed.
    await ref.read(authenticationProvider).signOut();
    ref.invalidate(studentDocProvider);
    ref.invalidate(authStateProvider);
    if (context.mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const AuthChecker(),
      ));
    }
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  const CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StudentDailyScheduleScreen(),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 250, 238, 188),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                category.thumbnail,
                height: kCategoryCardImageSize,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              category.name,
              style:
                  GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
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
                "Schedule",
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
