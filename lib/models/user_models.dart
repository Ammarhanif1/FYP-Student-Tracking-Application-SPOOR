// All these user models are stored by their firebase ID as identifier.

// ! Note: it would be better to convert these classes to "serializable" in a
// automated manner using something like "freezed" package.
import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  /// While username can be stored in FirebaseAuth, it cannot be displayed and
  /// cannot be queried without logging in.
  String username = "";

  /// Attendance contains a course name mapped to a List of [Timestamp] of each day
  /// the course was attended. For example:
  ///
  /// "Flutter for noobs": ["March 7th 2023", "March 9th 2023"]

  Map<String, List<Timestamp>> attendance = {};

  GeoPoint? lastLocation;

  String? parentDeviceToken;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "username": username,
      "attendance": attendance,
      "lastLocation": lastLocation,
      "parentDeviceToken": parentDeviceToken,
    };
  }

  static Student fromMap(Map<String, dynamic> from) {
    return Student()
      ..username = from['username'] as String
      ..parentDeviceToken = from['parentDeviceToken'] as String?
      ..attendance = (from['attendance'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, List<Timestamp>.from(value)))
      ..lastLocation = from['lastLocation'] as GeoPoint?;
  }
}

class Faculty {}

class Parent {
  /// Represents the Firebase ID of the child.
  String? childID;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "childID": childID,
    };
  }

  static Parent fromMap(Map<String, dynamic> from) {
    return Parent()..childID = from['childID'];
  }
}
