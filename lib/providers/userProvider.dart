import 'package:fashion_app/firebase/auth.dart';
import 'package:flutter/widgets.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = const User(
    username: "",
    uid: "",
    photoUrl: "",
    email: "",
    phoneNumber: "",
  );
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
