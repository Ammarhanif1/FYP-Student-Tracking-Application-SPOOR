import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/providers/user_doc_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ParentStudentLocation extends ConsumerStatefulWidget {
  const ParentStudentLocation({Key? key}) : super(key: key);

  @override
  _ParentStudentLocationState createState() => _ParentStudentLocationState();
}

class _ParentStudentLocationState extends ConsumerState<ParentStudentLocation> {
  @override
  Widget build(BuildContext context) {
    final studentParentRef = ref.watch(specificStudentDocProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Child Location"),
        ),
        body: studentParentRef.when(
            data: (data) => Center(
                  child: ElevatedButton(
                    child: const Text("Check child location"),
                    onPressed: () {
                      var location = data['lastLocation'] as GeoPoint;
                      launchUrl(Uri.parse(
                          "https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}"));
                    },
                  ),
                ),
            error: (error, stackTrace) =>
                const Text("Error while fetching data..."),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )));
  }
}
