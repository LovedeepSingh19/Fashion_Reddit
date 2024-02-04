import 'package:fashion_app/models/user.dart';
import 'package:fashion_app/providers/userProvider.dart';
import 'package:fashion_app/screens/WelcomePage.dart';
import 'package:fashion_app/widgets/NavigationBarWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<UserProvider>(context, listen: false).refreshUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final User userData =
        Provider.of<UserProvider>(context, listen: false).getUser;
    return Scaffold(
      body: userData.photoUrl != null
          ? NavigationBarWidget()
          : const CircularProgressIndicator(),
    );
  }
}
