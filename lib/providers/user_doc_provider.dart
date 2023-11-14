import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studentDocProvider = StreamProvider<DocumentSnapshot>((ref) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  return firestore
      .collection("students")
      .doc(auth.currentUser?.uid)
      .snapshots();
});

final specificStudentDocProvider = StreamProvider((ref) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final parentDoc = ref.watch(parentDocProvider);

  if (parentDoc.value == null || parentDoc.value!.data() == null) {
    // Return an empty stream if parentDoc is not yet available
    return const Stream.empty();
  } else {
    final childID = parentDoc.value!.get('childID');
    return firestore.collection("students").doc(childID).snapshots();
  }
});

/// This is different from [studentDocProvider]!.
/// This provides a snapshot of all the students as compared to [studentDocProvider],
/// which provides a single doc snapshot for the currently logged in student only.
final studentDocsProvider = StreamProvider<QuerySnapshot>((ref) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  return firestore.collection("students").snapshots();
});

final facultyDocProvider = StreamProvider<DocumentSnapshot>((ref) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  return firestore.collection("faculty").doc(auth.currentUser?.uid).snapshots();
});

final parentDocProvider = StreamProvider<DocumentSnapshot>((ref) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  return firestore.collection("parents").doc(auth.currentUser?.uid).snapshots();
});
