import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/models/post.dart';
import 'package:fashion_app/models/user.dart';
import 'package:fashion_app/providers/userProvider.dart';
import 'package:fashion_app/screens/DetailsPage.dart';
import 'package:fashion_app/screens/MyFeed.dart';
import 'package:fashion_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RightPart extends StatefulWidget {
  String? CategoryName;
  String? ColorName;
  String? BrandName;
  bool reset;
  RightPart(
      {this.CategoryName = "",
      this.BrandName = "",
      this.ColorName = "",
      required this.reset,
      Key? key})
      : super(key: key);

  @override
  _RightPartState createState() => _RightPartState();
}

class _RightPartState extends State<RightPart> with TickerProviderStateMixin {
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

  Stream<QuerySnapshot<Map<String, dynamic>>> query = FirebaseFirestore.instance
      .collection('posts')
      .orderBy("views", descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    final User userData = Provider.of<UserProvider>(context).getUser;
    return SingleChildScrollView(
        child: userData.uid == ""
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.only(top: 8),
                child: FutureBuilder<bool>(
                    future: getData(),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      } else {
                        return StreamBuilder(
                            stream: widget.reset
                                ? query
                                : (widget.BrandName != ""
                                    ? FirebaseFirestore.instance
                                        .collection('posts')
                                        .where("brand",
                                            isEqualTo: widget.BrandName)
                                        .snapshots()
                                    : (widget.ColorName != ""
                                        ? FirebaseFirestore.instance
                                            .collection('posts')
                                            .where("color",
                                                isEqualTo: widget.ColorName)
                                            .snapshots()
                                        : (widget.CategoryName != ""
                                            ? FirebaseFirestore.instance
                                                .collection('posts')
                                                .where("category",
                                                    isEqualTo:
                                                        widget.CategoryName)
                                                .snapshots()
                                            : query))),
                            // if (widget.reset) {
                            //   return query.snapshots();
                            // } else {
                            //   if (widget.BrandName != "") {
                            //     query = query.where("brand",
                            //         isEqualTo: widget.BrandName);
                            //   }
                            //   if (widget.ColorName != "") {
                            //     query = query.where("color",
                            //         isEqualTo: widget.ColorName);
                            //   }
                            //   if (widget.CategoryName != "") {
                            //     query = query.where("category",
                            //         isEqualTo: widget.CategoryName);
                            //   }

                            //   QuerySnapshot querySnapshot = query.snapshots();
                            // }
                            // }()
                            builder: (context,
                                AsyncSnapshot<
                                        QuerySnapshot<Map<String, dynamic>>>
                                    snapshot) {
                              if (snapshot.data != null &&
                                  snapshot.data!.docs.isEmpty) {
                                return const Center(
                                    child: Text(
                                  "Nothing to show",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ));
                              }

                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  snapshot.data == null) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height - 190,
                                child: GridView(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(8),
                                  scrollDirection: Axis.vertical,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 2.0,
                                    crossAxisSpacing: 10.0,
                                    childAspectRatio: 0.72,
                                  ),
                                  children: List<Widget>.generate(
                                    snapshot.data!.docs
                                        .where((doc) =>
                                            doc.data()['private'] != true)
                                        .length,
                                    (int index) {
                                      final int count =
                                          snapshot.data!.docs.length;
                                      final Animation<double> animation =
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(
                                        CurvedAnimation(
                                          parent: animationController!,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        ),
                                      );
                                      animationController?.forward();

                                      // Find the document where private is not true
                                      final category = snapshot.data!.docs
                                          .where((doc) =>
                                              doc.data()['private'] != true)
                                          .toList()[index]
                                          .data();

                                      return CategoryDiscoverView(
                                        category: category,
                                        animation: animation,
                                        animationController:
                                            animationController,
                                      );
                                    },
                                  ),
                                ),
                              );
                            });
                      }
                    })));
  }
}

class CategoryDiscoverView extends StatelessWidget {
  const CategoryDiscoverView({
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
