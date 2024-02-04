import 'package:fashion_app/models/chat_contact.dart';
import 'package:fashion_app/screens/MyFeed.dart';
import 'package:fashion_app/screens/chatting/chattingScreen.dart';
import 'package:fashion_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContactsList extends StatefulWidget {
  final int count;
  final int index;
  final ChatContact groupData;
  final bool group;

  ContactsList(
      {required this.count,
      required this.index,
      required this.groupData,
      required this.group,
      Key? key})
      : super(key: key);

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList>
    with TickerProviderStateMixin {
  AnimationController? animationController1;
  @override
  void initState() {
    animationController1 = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    if (animationController1 != null) {
      animationController1!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController1!,
        curve: Interval((1 / widget.count) * widget.index, 1.0,
            curve: Curves.fastOutSlowIn),
      ),
    );
    animationController1?.forward();

    return AnimatedBuilder(
      animation: animationController1!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
            opacity: animation,
            child: Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  50 * (1.0 - animation.value),
                  0.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChattingScreen(
                                      name: widget.groupData.name,
                                      uid: widget.groupData.contactId,
                                      isGroupChat: widget.group,
                                      profilePic:
                                          widget.groupData.profilePic)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            title: Text(
                              widget.groupData.name,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                widget.groupData.lastMessage,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: SizedBox(
                                  height: 100,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.groupData.profilePic,
                                  ),
                                ),
                              ),
                            ),
                            trailing: Text(
                              DateFormat.Hm().format(widget.groupData.timeSent),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(color: AppTheme.darkText, indent: 85),
                    ],
                  ),
                )));
      },
    );
  }
}
