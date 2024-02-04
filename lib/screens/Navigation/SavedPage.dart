import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/models/post.dart';
import 'package:fashion_app/models/user.dart';
import 'package:fashion_app/providers/userProvider.dart';
import 'package:fashion_app/screens/DetailsPage.dart';
import 'package:fashion_app/screens/MyFeed.dart';
import 'package:fashion_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedPage extends StatefulWidget {
  SavedPage({Key? key}) : super(key: key);

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Saved"),
        ),
        body: Column(
          children: [
            SavedPageMainPart(),
          ],
        ));
  }
}

class SavedPageMainPart extends StatefulWidget {
  SavedPageMainPart({Key? key}) : super(key: key);

  @override
  _SavedPageMainPartState createState() => _SavedPageMainPartState();
}

class _SavedPageMainPartState extends State<SavedPageMainPart>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    if (animationController != null) {
      animationController!.stop();
      animationController!.dispose();
    }
    super.dispose();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final User userData = Provider.of<UserProvider>(context).getUser;
    return userData.uid == ""
        ? CircularProgressIndicator()
        : Padding(
            padding: const EdgeInsets.only(top: 8),
            child: FutureBuilder<bool>(
                future: getData(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(userData.uid)
                            .collection("SavedPosts")
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.data != null &&
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                                child: Text(
                              "Nothing's saved yet",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Container(
                            height: MediaQuery.sizeOf(context).height - 220,
                            child: GridView(
                              padding: const EdgeInsets.all(8),
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 2.0,
                                crossAxisSpacing: 2.0,
                                childAspectRatio: 0.6,
                              ),
                              children: List<Widget>.generate(
                                snapshot.data!.docs.length,
                                (int index) {
                                  final int count = snapshot.data!.docs.length;
                                  final Animation<double> animation =
                                      Tween<double>(begin: 0.0, end: 1.0)
                                          .animate(
                                    CurvedAnimation(
                                      parent: animationController!,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  );
                                  animationController?.forward();
                                  return SavedDataView(
                                    // callback: widget.callBack,x
                                    category: snapshot.data!.docs[index].data(),
                                    animation: animation,
                                    animationController: animationController,
                                  );
                                },
                              ),
                            ),
                          );
                        });
                  }
                }));
  }
}

class SavedDataView extends StatelessWidget {
  const SavedDataView({
    Key? key,
    required this.category,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final category;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              50 * (1.0 - animation!.value),
              0.0,
            ),
            child: InkWell(
              splashColor: Colors.transparent,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 200,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 5, left: 5, bottom: 5),
                          child: Text(
                            category!['title'],
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.27,
                              color: AppTheme.nearlyBlack,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: AppTheme.grey.withOpacity(0.2),
                                offset: const Offset(0.0, 0.0),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16.0)),
                              child: Container(
                                height: 152,
                                child: CachedNetworkImage(
                                  imageUrl: category['postUrl'],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () async {
                final Post post = Post(
                    description: category["description"],
                    title: category["title"],
                    uid: category["uid"],
                    username: category["username"],
                    postId: category["postId"],
                    datePublished:
                        (category["datePublished"] as Timestamp).toDate(),
                    postUrl: category["postUrl"],
                    profImage: category["profImage"],
                    private: category["private"],
                    views: category["views"]);
                await updateViews(category['postId']);
                // ignore: use_build_context_synchronously
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPage(
                              imageUrl: category['postUrl'],
                              post: post,
                            )));
              },
            ),
          ),
        );
      },
    );
  }
}
