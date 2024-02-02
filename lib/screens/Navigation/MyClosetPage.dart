import 'package:fashion_app/firebase/auth.dart';
import 'package:fashion_app/screens/AddPostScreen.dart';
import 'package:fashion_app/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyClosetPage extends StatefulWidget {
  MyClosetPage({Key? key}) : super(key: key);

  @override
  _MyClosetPageState createState() => _MyClosetPageState();
}

class _MyClosetPageState extends State<MyClosetPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const SizedBox(height: 50),
                  InkWell(
                    child: const Icon(
                      CupertinoIcons.profile_circled,
                      size: 100,
                    ),
                    onTap: () {},
                  ),
                  const Text('Name'),
                  // Text(Auth().currentUser!.email!)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "My Closet",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.orange,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddPostScreen()));
                          },
                          child: const Icon(
                            CupertinoIcons.add_circled,
                            color: Colors.white,
                          )),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Add New",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: AppTheme.lightText),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            AuthMethods().signOut();
                          },
                          child: Text("data"))
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
