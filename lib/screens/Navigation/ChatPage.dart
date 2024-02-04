import 'package:fashion_app/firebase/auth.dart';
import 'package:fashion_app/models/chat_contact.dart';
import 'package:fashion_app/screens/WelcomePage.dart';
import 'package:fashion_app/screens/chatting/chatController/chatController.dart';
import 'package:fashion_app/screens/chatting/contactsList.dart';
import 'package:fashion_app/screens/chatting/select_contacts.dart';
import 'package:fashion_app/screens/groups/CreateGroupScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final searchController = TextEditingController();

  bool searching = false;
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Color.fromARGB(116, 237, 240, 242),
          centerTitle: !searching, // Use !searching here
          title: searching
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        hintText: 'Search',
                        contentPadding:
                            const EdgeInsets.only(left: 40, right: 10),
                      ),
                    ),
                  ),
                )
              : const Text("Chats"),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {
                setState(() {
                  searching = !searching;
                });
              },
            ),
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                    child: const Text(
                      'Create Group',
                    ),
                    onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateGroupScreen()))
                        }),
                PopupMenuItem(
                    child: const Text(
                      'Logout',
                    ),
                    onTap: () {
                      AuthMethods().signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomePage()));
                    })
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SelectContactsPage()));
          },
          child: const Icon(CupertinoIcons.add),
        ),
        body: SingleChildScrollView(
            child: FutureBuilder<bool>(
                future: getData(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    return StreamBuilder<List<ChatContact>>(
                        stream: ChatController().getChatContacts(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          // var firstDocument = snapshot.data!.docs;
                          // List<dynamic> contacts = firstDocument[0]["contacts"];
                          // final count = contacts.length;

                          return snapshot.data!.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 100),
                                  child: Center(
                                    child: Text(
                                      "No Contacts added",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          final groupData =
                                              snapshot.data![index];
                                          return ContactsList(
                                            count: snapshot.data!.length,
                                            index: index,
                                            groupData: groupData,
                                            group: false,
                                          );
                                        })
                                  ],
                                );
                        });
                  }
                })));
  }
}
