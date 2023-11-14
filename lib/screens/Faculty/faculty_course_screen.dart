import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/providers/courses_docs_provider.dart';
import 'package:fyp/screens/Faculty/faculty_attendance_screen.dart';
import 'package:fyp/screens/Faculty/faculty_course_creation_screen.dart';

class FacultyCourseScreen extends ConsumerStatefulWidget {
  const FacultyCourseScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FacultyCourseScreenState();
}

class _FacultyCourseScreenState extends ConsumerState<FacultyCourseScreen> {
  @override
  Widget build(BuildContext context) {
    var courses = ref.watch(courseDocsProvider);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Courses"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const FacultyCourseCreationScreen(),
                  ));
                },
                icon: const Icon(Icons.create))
          ],
        ),
        body: courses.when(
            data: (data) {
              return ListView(
                children: [
                  ...data.docs.map((e) => ListTile(
                        title: Text(
                          e.id,
                        ),
                        trailing: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    FacultyAttendanceScreen(e.id),
                              ));
                            },
                            icon: const Icon(Icons.arrow_right_alt),
                            label: const Text("Set Attendance")),
                      ))
                ],
              );
            },
            error: (error, stackTrace) => const Center(
                  child: Text("An error occured while fetching data..."),
                ),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )));
  }
}
