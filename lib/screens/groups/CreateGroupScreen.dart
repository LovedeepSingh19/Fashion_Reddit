import 'dart:io';

import 'package:fashion_app/screens/chatting/chatController/selectionController.dart';
import 'package:fashion_app/screens/groups/GroupController.dart';
import 'package:fashion_app/theme/app_theme.dart';
import 'package:fashion_app/utils/utils.dart';
import 'package:fashion_app/widgets/SelectContactGroups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupScreen extends StatefulWidget {
  CreateGroupScreen({Key? key}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  File? image;
  bool loading = false;
  List<Contact> selectedContacts = [];

  Future<File?> pickImageFromGallery(BuildContext context) async {
    File? image;
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return image;
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  List<Contact>? contactList;

  Future<void> createGroup() async {
    if (groupNameController.text.trim().isNotEmpty &&
        image != null &&
        loading == false) {
      contactList = await SelectionController().getContacts();
      setState(() {});
      // ignore: use_build_context_synchronously
      GroupController().createGroup(
        context,
        groupNameController.text.trim(),
        image!,
        selectedContacts,
      );
      Navigator.pop(context);
    }
    print("called");
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                        ),
                        radius: 64,
                      )
                    : CircleAvatar(
                        backgroundImage: FileImage(
                          image!,
                        ),
                        radius: 64,
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: groupNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter Group Name',
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Select Contacts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SelectContactGroups(
              loading: false,
              selectedContacts: selectedContacts,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createGroup(),
        backgroundColor: AppTheme.dark_grey,
        child: loading
            ? const CircularProgressIndicator()
            : const Icon(
                Icons.done,
                color: Colors.white,
              ),
      ),
    );
  }
}
