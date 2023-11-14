import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/models/student_course.dart';

class FacultyCourseCreationScreen extends ConsumerStatefulWidget {
  const FacultyCourseCreationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FacultyCourseCreationScreenState();
}

class _FacultyCourseCreationScreenState
    extends ConsumerState<FacultyCourseCreationScreen> {
  final _courseName = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  List<DateTime> times = [];
  List<String> weekdayLocal = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  //  A loading variable to show the loading animation when you a function is ongoing
  bool _isLoading = false;
  void loading() {
    if (mounted) {
      setState(() {
        _isLoading = !_isLoading;
      });
    }
  }

  Future<void> onCreateCourse() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (times.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please select atleast one course day."),
        backgroundColor: Color.fromRGBO(244, 67, 54, 1),
      ));
      return;
    }
    loading();
    var db = FirebaseFirestore.instance;
    await db
        .collection("courses")
        .doc(_courseName.text)
        .set(StudentCourse(times).toMap());
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  showPicker() async {
    if (times.length > 7) {
      return;
    }
    DateTime? dt = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (dt != null) {
      if (times.contains(dt)) {
        return;
      }
      setState(() {
        times.add(dt);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Course"),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _courseName,
                  keyboardType: TextInputType.name,
                  onSaved: (_) {},
                  decoration: const InputDecoration(
                    prefix: Text(' '),
                    hintText: 'Course Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Invalid course name!';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    showPicker();
                  },
                  label: const Text("Add course date")),
              ...times.map((e) => ListTile(
                    title: Text(weekdayLocal[e.weekday - 1]),
                  )),
              !_isLoading
                  ? ElevatedButton(
                      onPressed: onCreateCourse,
                      child: const Text("Create Course"))
                  : const Center(
                      child: CircularProgressIndicator(),
                    )
            ],
          )),
    );
  }
}
