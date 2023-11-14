import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('emergencyContacts').listenable(),
      builder: (context, value, child) {
        Map contactsList = value.get('contactsList', defaultValue: {});
        return Scaffold(
            appBar: AppBar(
              title: const Text("Emergency Contacts"),
              actions: [
                IconButton(
                    onPressed: () {
                      createEmergencyContact(value);
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
            body: ListView.builder(
              itemBuilder: (context, index) => ListTile(
                title: Text(contactsList.keys.elementAt(index)),
                subtitle: Text(contactsList.values.elementAt(index)),
                trailing: const Text("Tap to call"),
                onTap: () {
                  callNumber(contactsList.values.elementAt(index));
                },
              ),
              itemCount: contactsList.length,
            ));
      },
    );
  }

  void createEmergencyContact(Box<dynamic> box) async {
    if (!await FlutterContactPicker.hasPermission()) {
      var result = await FlutterContactPicker.requestPermission();
      if (!result) return;
    }
    final FullContact contact = await FlutterContactPicker.pickFullContact();
    Map contactsList = await box.get('contactsList', defaultValue: {});
    contactsList[contact.name?.nickName ?? contact.name?.firstName ?? "-"] =
        contact.phones[0].number;
    await box.put('contactsList', contactsList);
  }

  void callNumber(String number) async {
    await launchUrl(Uri(scheme: 'tel', path: number));
  }
}
