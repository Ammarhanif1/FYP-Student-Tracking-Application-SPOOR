import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/providers/user_doc_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../reusable_widgets/circle_button.dart';

class StudentLocationScreen extends ConsumerStatefulWidget {
  const StudentLocationScreen({Key? key}) : super(key: key);

  @override
  _StudentLocationScreenState createState() => _StudentLocationScreenState();
}

class _StudentLocationScreenState extends ConsumerState<StudentLocationScreen> {
  bool sending = false;
  sendLocation() async {
    setState(() {
      sending = true;
    });
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("Error: Location Services Disabled!!");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("Error: Location Permission denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint("Error: Location Permissions denied forever");
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var currentLocation = await Geolocator.getCurrentPosition();
    await ref.read(studentDocProvider).value?.reference.set({
      "lastLocation":
          GeoPoint(currentLocation.latitude, currentLocation.longitude)
    }, SetOptions(merge: true));
    setState(() {
      sending = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Student location updates are sent every 100m automatically. To force send your location press the button below.",
            style:
                GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          sending
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: sendLocation,
                  child: Text(
                    "Send Location",
                    style: GoogleFonts.nunito(fontSize: 18),
                  )),
        ],
      ),
    );
  }
}

appbar() {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: const Color(0xff886ff2),
    centerTitle: true,
    leading: CircleButton(
      icon: Icons.settings,
      onPressed: () {},
    ),
    actions: [
      CircleButton(
        icon: Icons.chat_rounded,
        onPressed: () {},
      ),
    ],
    title: Text(
      "Location",
      style: GoogleFonts.nunito(
          fontSize: 25, fontWeight: FontWeight.normal, color: Colors.white),
    ),
  );
}
