import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/models/post.dart';
import 'package:fashion_app/models/user.dart';
import 'package:fashion_app/providers/userProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final String imageUrl;
  final Post post;

  DetailPage({required this.imageUrl, required this.post, Key? key})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  saveFunction(User user) async {
    print("save");
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("SavedPosts")
        .doc(widget.post.postId)
        .set(widget.post.toJson());
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.2),
                              child: const Icon(
                                CupertinoIcons.chevron_back,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(FontAwesomeIcons.xmark),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                              'Options',
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        buildOption('Follow'),
                                        buildOption('Copy link'),
                                        buildOption('Download image'),
                                        buildOption('Hide Pin'),
                                        buildOption('Report Pin'),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "This goes against Pinterest's community guidelines",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              );
                            },
                            child: const Icon(
                              CupertinoIcons.ellipsis,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: const Icon(
                          CupertinoIcons.viewfinder,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 30,
                left: 18,
                right: 18,
              ),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(CupertinoIcons.heart_circle_fill),
                  Row(
                    children: [
                      buildOption('View'),
                      const SizedBox(
                        width: 6,
                      ),
                      InkWell(
                          child: buildOption('Save', textColor: Colors.white),
                          onTap: () async {
                            await saveFunction(user);
                          }),
                    ],
                  ),
                  const Icon(Icons.share),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOption(String text, {Color textColor = Colors.black}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
      decoration: BoxDecoration(
        color: textColor == Colors.white
            ? Theme.of(context).colorScheme.secondary
            : const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
