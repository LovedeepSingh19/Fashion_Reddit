import 'package:fashion_app/models/chat_contact.dart';
import 'package:fashion_app/screens/chatting/chatController/selectionController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

class SelectContactsPage extends StatefulWidget {
  SelectContactsPage({Key? key}) : super(key: key);

  @override
  _SelectContactsPageState createState() => _SelectContactsPageState();
}

class _SelectContactsPageState extends State<SelectContactsPage> {
  List<Contact>? contactList;

  getconts() async {
    contactList = await SelectionController().getContacts();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getconts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: contactList == null
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: contactList!.length,
              itemBuilder: (context, index) {
                final contact = contactList![index];
                return InkWell(
                  onTap: () => SelectionController()
                      .selectContact(contact, context, false),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      leading: contact.photo == null
                          ? null
                          : CircleAvatar(
                              backgroundImage: MemoryImage(contact.photo!),
                              radius: 30,
                            ),
                    ),
                  ),
                );
              }),
    );
  }
}
