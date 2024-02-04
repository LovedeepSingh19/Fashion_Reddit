import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/models/chat_contact.dart';
import 'package:fashion_app/models/post.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String phoneNumber;

  const User({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.phoneNumber,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      phoneNumber: snapshot["phoneNumber"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "phoneNumber": phoneNumber,
      };
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? "",
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}

Stream<User> userData(String userId) {
  final firestore = FirebaseFirestore.instance;
  return firestore.collection('users').doc(userId).snapshots().map(
        (event) => User.fromMap(
          event.data()!,
        ),
      );
}
