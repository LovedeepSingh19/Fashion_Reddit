import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/models/user.dart';
import 'package:fashion_app/screens/chatting/chattingScreen.dart';
import 'package:fashion_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class SelectionController {
  final firestore = FirebaseFirestore.instance;

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void removeContact(List<Contact> contactList, Contact contact) {
    contactList.remove(contact);
  }

  void selectContact(
      Contact selectedContact, BuildContext context, bool isGroup) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = User.fromMap(document.data());
        String selectedPhoneNum = selectedContact.phones[0].number
            .replaceAll(
              ' ',
              '',
            )
            .replaceAll("-", "");
        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          if (!isGroup) {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ChattingScreen(
                      name: userData.username,
                      uid: userData.uid,
                      isGroupChat: false,
                      profilePic: userData.photoUrl),
                ));
          }
        }
      }

      if (!isFound) {
        showSnackBar(
          context,
          'This number does not exist on this app.',
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
