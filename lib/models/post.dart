import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String title;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final String? link;
  final String? brand;
  final String? color;
  final String? category;
  final bool private;
  final int views;

  const Post({
    required this.description,
    required this.title,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    this.link,
    this.brand,
    this.color,
    this.category,
    required this.private,
    required this.views,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot["description"],
      title: snapshot["title"],
      uid: snapshot["uid"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      username: snapshot["username"],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      link: snapshot['link'],
      brand: snapshot['brand'],
      color: snapshot['color'],
      category: snapshot['category'],
      private: snapshot['private'],
      views: snapshot['views'],
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "title": title,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'link': link,
        'brand': brand,
        'color': color,
        'category': category,
        'private': private,
        'views': views,
      };
}

Future<void> updateViews(String postId) async {
  try {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference postRef =
          FirebaseFirestore.instance.collection("posts").doc(postId);

      DocumentSnapshot postSnapshot = await transaction.get(postRef);
      if (postSnapshot.exists) {
        int currentViews = postSnapshot.get('views') ?? 0;
        int newViews = currentViews + 1;

        transaction.update(postRef, {'views': newViews});
      }
    });
  } catch (e) {
    print("Error updating views: $e");
  }
}

List<String> postCategories = <String>[
  '',
  'Trouser',
  'hoodie',
  'jeans',
  'socks',
  'shoes'
];
