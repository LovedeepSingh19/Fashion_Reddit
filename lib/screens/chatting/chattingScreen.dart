import 'package:fashion_app/firebase/FireStoreMethod.dart';
import 'package:fashion_app/models/user.dart';
import 'package:fashion_app/theme/app_theme.dart';
import 'package:fashion_app/widgets/BottomChatField.dart';
import 'package:fashion_app/widgets/ChatList.dart';
import 'package:flutter/material.dart';

class ChattingScreen extends StatefulWidget {
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;
  ChattingScreen(
      {required this.name,
      required this.uid,
      required this.isGroupChat,
      required this.profilePic,
      Key? key})
      : super(key: key);

  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.spacer,
        title: widget.isGroupChat
            ? Text(widget.name)
            : StreamBuilder<User>(
                stream: userData(widget.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return Column(
                    children: [
                      Text(widget.name),
                      Text(
                        snapshot.data!.username,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.lightText,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  );
                }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              recieverUserId: widget.uid,
              isGroupChat: widget.isGroupChat,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
            child: BottomChatField(
              recieverUserId: widget.uid,
              recieverUserName: widget.name,
              isGroupChat: widget.isGroupChat,
            ),
          ),
        ],
      ),
    );
  }
}
