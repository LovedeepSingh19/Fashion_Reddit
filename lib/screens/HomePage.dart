import 'package:fashion_app/screens/WelcomePage.dart';
import 'package:fashion_app/widgets/NavigationBarWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavigationBarWidget(),
    );
    // Container(
    //   child: Column(
    //     children: [
    //       Text('Ahhhh... shit here we go again'),
    //       ElevatedButton(
    //           onPressed: () async {
    //             await Auth().signOut();
    //             Navigator.push(context,
    //                 MaterialPageRoute(builder: (context) => WelcomePage()));
    //           },
    //           child: Text("logout"))
    //     ],
    //   ),
    // );
  }
}
