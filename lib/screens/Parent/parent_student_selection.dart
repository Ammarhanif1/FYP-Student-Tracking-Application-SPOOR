import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/providers/auth_provider.dart';
import 'package:fyp/providers/user_doc_provider.dart';

class ParentStudentSelection extends ConsumerStatefulWidget {
  const ParentStudentSelection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ParentStudentSelectionState();
}

class _ParentStudentSelectionState
    extends ConsumerState<ParentStudentSelection> {
  updateChildID(var childUID) async {
    var db = FirebaseFirestore.instance;
    var parentUID = ref.read(authStateProvider).value?.uid;

    if (parentUID == null) return;

    await db.collection('parents').doc(parentUID).update({'childID': childUID});
  }

  @override
  Widget build(BuildContext context) {
    var studentsRef = ref.watch(studentDocsProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Select Child"),
      ),
      body: studentsRef.when(
          data: (data) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data.docs[index].get('username')),
                  trailing: const Icon(Icons.arrow_circle_right_outlined),
                  onTap: () {
                    updateChildID(data.docs[index].id);
                  },
                );
              },
              itemCount: data.docs.length,
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
