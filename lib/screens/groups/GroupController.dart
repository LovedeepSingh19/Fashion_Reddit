import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/models/group.dart' as model;
import 'package:fashion_app/screens/chatting/common/commonFirebaseGroups.dart';
import 'package:fashion_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:uuid/uuid.dart';

class GroupController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void createGroup(BuildContext context, String name, File profilePic,
      List<Contact> selectedContact) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContact.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: selectedContact[i]
                  .phones[0]
                  .number
                  .replaceAll(
                    ' ',
                    '',
                  )
                  .replaceAll("-", ""),
            )
            .get();

        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }
      var groupId = const Uuid().v1();

      String profileUrl =
          await CommonFirebaseStorageRepository().storeFileToFirebase(
        'group/$groupId',
        profilePic,
      );
      model.Group group = model.Group(
        senderId: auth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: '',
        groupPic: profileUrl,
        membersUid: [auth.currentUser!.uid, ...uids],
        timeSent: DateTime.now(),
      );
      print("uids");
      print(uids.length);
      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
