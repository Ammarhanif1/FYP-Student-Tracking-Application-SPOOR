import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final courseDocsProvider = StreamProvider<QuerySnapshot>((ref) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  return firestore.collection("courses").snapshots();
});
