import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/providers/auth_provider.dart';
import 'package:fyp/screens/auth/auth_check.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/user_doc_provider.dart';

class FacultyLocationScreen extends ConsumerStatefulWidget {
  const FacultyLocationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FacultyLocationScreenState();
}

class _FacultyLocationScreenState extends ConsumerState<FacultyLocationScreen> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? docs;
  var loading = true;
  getStudents() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var snapshot = await firestore
        .collection("students")
        .where("lastLocation", isNull: false)
        .get();

    setState(() {
      docs = snapshot.docs;
      loading = false;
    });
  }

  @override
  void initState() {
    getStudents();
    super.initState();
  }

  signoutuser(WidgetRef ref) async {
    ref.read(authenticationProvider).signOut();
    ref.invalidate(studentDocProvider);
    ref.invalidate(authStateProvider);
    if (context.mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const AuthChecker(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Locations"),
        actions: [
          IconButton(
              onPressed: () {
                signoutuser(ref);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: List.generate(
                  docs?.length ?? 0,
                  (index) => ListTile(
                        title: Text(
                            docs?[index].data()['username'] ?? docs![index].id),
                        leading: const Icon(Icons.location_on),
                        onTap: () {
                          var location =
                              docs![index].data()['lastLocation'] as GeoPoint;
                          launchUrl(Uri.parse(
                              "https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}"));
                        },
                      )),
            ),
    );
  }
}
