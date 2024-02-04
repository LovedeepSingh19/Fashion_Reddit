import 'package:fashion_app/screens/chatting/chatController/selectionController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

class SelectContactGroups extends StatefulWidget {
  bool loading;
  List<Contact> selectedContacts;
  SelectContactGroups(
      {required this.loading, required this.selectedContacts, Key? key})
      : super(key: key);

  @override
  _SelectContactGroupsState createState() => _SelectContactGroupsState();
}

class _SelectContactGroupsState extends State<SelectContactGroups> {
  List<int> selectedContactsIndex = [];
  selectSingleContact(int index, Contact contact, BuildContext context) {
    selectedContactsIndex.add(index);

    widget.selectedContacts.add(contact);
  }

  Future<void> selectContact(
      int index, Contact contact, BuildContext context) async {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.remove(index);
      widget.selectedContacts.remove(contact);
    } else {
      selectedContactsIndex.add(index);
      widget.selectedContacts.add(contact);
    }
    setState(() {});
  }

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
    return contactList == null
        ? const CircularProgressIndicator()
        : Expanded(
            child: ListView.builder(
                itemCount: contactList!.length,
                itemBuilder: (context, index) {
                  final contact = contactList![index];
                  return InkWell(
                    onTap: () async =>
                        await selectContact(index, contact, context),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: selectedContactsIndex.contains(index)
                            ? IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.done),
                              )
                            : null,
                      ),
                    ),
                  );
                }),
          );
  }
}
