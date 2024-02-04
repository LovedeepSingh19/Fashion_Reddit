import 'package:fashion_app/firebase/auth.dart';
import 'package:fashion_app/providers/userProvider.dart';
import 'package:fashion_app/screens/AddPostScreen.dart';
import 'package:fashion_app/screens/MyFeed.dart';
import 'package:fashion_app/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';

class MyClosetPage extends StatefulWidget {
  MyClosetPage({Key? key}) : super(key: key);

  @override
  _MyClosetPageState createState() => _MyClosetPageState();
}

class _MyClosetPageState extends State<MyClosetPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Simulating a delay to demonstrate the loading state
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final User userData = Provider.of<UserProvider>(context).getUser;
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 100,
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
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.network(
                          userData.photoUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return const Center(
                              child: Icon(
                                CupertinoIcons.profile_circled,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Text(
                      userData.username,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      userData.email,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "My Closet",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                      ],
                    ),
                  ],
                )
              ],
            ),
            const Expanded(
              child: FeedScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
