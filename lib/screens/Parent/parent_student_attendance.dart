import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:fyp/models/user_models.dart';
import 'package:fyp/providers/user_doc_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class ParentAttendance extends ConsumerStatefulWidget {
  const ParentAttendance({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ParentAttendanceState();
}

class _ParentAttendanceState extends ConsumerState<ParentAttendance> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final studentParentRef = ref.watch(specificStudentDocProvider);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Your attendance"),
        ),
        body: studentParentRef.when(
            data: (doc) {
              Map<String, dynamic>? studentParentDoc =
                  doc.data() as Map<String, dynamic>?;

              if (studentParentDoc == null) {
                return const Text("User returned null");
              }

              Student student = Student.fromMap(studentParentDoc);

              return ListView.builder(
                itemCount: student.attendance.length,
                itemBuilder: (context, index) {
                  var key = student.attendance.keys.elementAt(index);
                  var value = student.attendance.values.elementAt(index);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpansionTile(
                        title: Text("$key (${value.length})"),
                        initiallyExpanded: false,
                        leading: const Icon(Icons.arrow_circle_right_outlined),
                        children: List.generate(
                          value.length,
                          (i) => Text(
                            "${i + 1}) ${DateFormat.yMMMMEEEEd().format((value[i]).toDate())}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            error: (e, stackTrace) {
              return Text("Error Fetching Data: $e");
            },
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )));
  }
}
