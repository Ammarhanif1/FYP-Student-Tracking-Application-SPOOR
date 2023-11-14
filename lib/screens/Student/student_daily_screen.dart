import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/providers/courses_docs_provider.dart';

class StudentDailyScheduleScreen extends ConsumerStatefulWidget {
  const StudentDailyScheduleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StudentDailyScheduleScreenState();
}

class _StudentDailyScheduleScreenState
    extends ConsumerState<StudentDailyScheduleScreen> {
  int periods = 7;
  List<String> weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  @override
  Widget build(BuildContext context) {
    var courses = ref.watch(courseDocsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Schedule"),
      ),
      body: courses.when(
          data: (data) {
            Map<String, List<String>> timings = {};
            for (var element in weekdays) {
              timings[element] = [];
            }
            for (var element in data.docs) {
              var timestamps = element.get('courseTimings') as List<dynamic>;
              for (var timestamp in timestamps) {
                timings[weekdays[timestamp.toDate().weekday - 1]]
                    ?.add(element.id);
              }
            }
            debugPrint("$timings");
            return InteractiveViewer(
              constrained: false,
              child: DataTable(
                  border: TableBorder.all(color: Colors.grey),
                  columns: [
                    const DataColumn(label: Text("Day")),
                    ...List.generate(
                        periods,
                        (index) =>
                            DataColumn(label: Text("Period ${index + 1}")))
                  ],
                  rows: List.generate(
                      timings.keys.length,
                      (rowIndex) => DataRow(cells: [
                            DataCell(Text(weekdays[rowIndex])),
                            ...List.generate(
                                periods,
                                (colIndex) => DataCell(Text(
                                    timings.values.elementAt(rowIndex).length >
                                            colIndex
                                        ? timings.values
                                            .elementAt(rowIndex)
                                            .elementAt(colIndex)
                                        : "-")))
                          ]))),
            );
          },
          error: (error, stackTrace) =>
              const Text("Error while fetching data..."),
          loading: () => const Center(
                child: CircularProgressIndicator(),
              )),
    );
  }
}
