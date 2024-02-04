import 'dart:typed_data';

import 'package:fashion_app/firebase/FireStoreMethod.dart';
import 'package:fashion_app/models/post.dart';
import 'package:fashion_app/providers/userProvider.dart';
import 'package:fashion_app/screens/HomePage.dart';
import 'package:fashion_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  bool isPrivate = false;
  final titleController = TextEditingController();
  final colorController = TextEditingController();
  final brandController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  String selectedValue = postCategories[0];

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource.gallery);
                  if (file == null) {
                    Navigator.pop(context);
                  }
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
        titleController.text,
        isPrivate,
        colorController.text,
        brandController.text,
        linkController.text,
        selectedValue,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
        clearImage();
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    brandController.dispose();
    colorController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    // return _file == null
    //     ? Center(
    //         child: IconButton(
    //           icon: const Icon(
    //             Icons.upload,
    //           ),
    //           onPressed: () => _selectImage(context),
    //         ),
    //       )
    //     :
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Closet Item'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                isLoading
                    ? const LinearProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(),
                      ),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Enter Title here',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(18),
                  ),
                  maxLength: 30,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {},
                  child:
                      // DottedBorder(
                      //   borderType: BorderType.RRect,
                      //   radius: const Radius.circular(10),
                      //   dashPattern: const [10, 4],
                      //   strokeCap: StrokeCap.round,
                      //   color:
                      //       currentTheme.textTheme.bodyText2!.color!,
                      //   child:
                      InkWell(
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _file == null
                            ? const Icon(
                                Icons.camera_alt_outlined,
                                size: 40,
                              )
                            : AspectRatio(
                                aspectRatio: 487 / 451,
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    fit: BoxFit.fill,
                                    alignment: FractionalOffset.topCenter,
                                    image: MemoryImage(_file!),
                                  )),
                                ),
                              ),
                      ),
                    ),
                    onTap: () => _selectImage(context),
                  ),
                  // ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Enter Description here',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(18),
                  ),
                  maxLines: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child: Row(
                        children: [
                          Checkbox(
                            value: isPrivate,
                            onChanged: (value) {
                              setState(() {
                                isPrivate = !isPrivate;
                              });
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text("Private"),
                          ),
                        ],
                      ),
                    ),
                    DropdownButton<String>(
                      value: selectedValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                      items: postCategories.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width / 2 - 20,
                      child: TextField(
                        controller: colorController,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter Color here',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                        maxLength: 20,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width / 2 - 20,
                      child: TextField(
                        controller: brandController,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter Brand',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                        maxLength: 20,
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: linkController,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Have a Link?? Enter here....',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(18),
                  ),
                  maxLength: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => postImage(
                      userProvider.getUser.uid,
                      userProvider.getUser.username,
                      userProvider.getUser.photoUrl,
                    ),
                    child: const Text("Add Item"),
                  ),
                )
              ],
            )));
  }
}
