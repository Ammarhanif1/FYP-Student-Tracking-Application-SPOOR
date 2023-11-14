import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:fyp/providers/user_doc_provider.dart';

class FacultyAttendanceScreen extends ConsumerStatefulWidget {
  const FacultyAttendanceScreen(this.course, {super.key});
  final String course;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FacultyAttendanceScreenState();
}

class _FacultyAttendanceScreenState
    extends ConsumerState<FacultyAttendanceScreen> {
  Map<int, bool> selected = {};
  @override
  void initState() {
    super.initState();
  }

  //  A loading variable to show the loading animation when you a function is ongoing
  bool _isLoading = false;
  void loading() {
    if (mounted) {
      setState(() {
        _isLoading = !_isLoading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var studentsRef = ref.watch(studentDocsProvider);
    return Scaffold(
        appBar: AppBar(title: const Text("Attendance")),
        body: studentsRef.when(
            data: (msg) {
              var students = msg.docs;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Course: ${widget.course}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    Text(
                      "Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    Text(
                      "Students: ${students.length}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    !_isLoading
                        ? ElevatedButton(
                            onPressed: () {
                              submitAttendance(students);
                            },
                            child: const Text("Submit attendance"))
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: DataTable(
                          border: TableBorder.all(color: Colors.grey),
                          columns: const [
                            DataColumn(label: Text("Student Name"))
                          ],
                          rows: List<DataRow>.generate(
                            students.length,
                            (index) => DataRow(
                              cells: [
                                DataCell(
                                  Text("${students[index].get('username')}"),
                                )
                              ],
                              color: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                // All rows will have the same selected color.
                                if (states.contains(MaterialState.selected)) {
                                  return Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.08);
                                }
                                // Even rows will have a grey color.
                                if (index.isEven) {
                                  return Colors.grey.withOpacity(0.3);
                                }
                                return null; // Use default value for other states and odd rows.
                              }),
                              selected: selected.containsKey(index)
                                  ? selected[index]!
                                  : false,
                              onSelectChanged: (value) {
                                setState(() {
                                  selected[index] = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (error, stackTrace) => const Center(
                child: Text("An error occured while fetching data...")),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )));
  }

  void submitAttendance(List<QueryDocumentSnapshot<Object?>> docs) async {
    loading();

    var db = FirebaseFirestore.instance;
    var batch = db.batch();
    var count = 0;

    selected.forEach((key, value) async {
      if (value) {
        batch.set(
            docs[key].reference,
            {
              'attendance': {
                widget.course: FieldValue.arrayUnion([Timestamp.now()])
              }
            },
            SetOptions(merge: true));
        if (++count >= 500) {
          await batch.commit();
          batch = db.batch();
          count = 0;
        }
      }
    });
    await batch.commit();
    loading();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
