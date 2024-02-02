import 'package:fashion_app/screens/Navigation/ChatPage.dart';
import 'package:fashion_app/screens/Navigation/DiscoverPage.dart';
import 'package:fashion_app/screens/Navigation/GroupsPage.dart';
import 'package:fashion_app/screens/Navigation/MyClosetPage.dart';
import 'package:fashion_app/screens/Navigation/SavedPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationBarWidget extends StatefulWidget {
  NavigationBarWidget({Key? key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBarWidget> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    MyClosetPage(),
    GroupsPage(),
    DiscoverPage(),
    SavedPage(),
    ChatPage(),
  ];
  final List<String> _titles = [
    "My Closet",
    "Groups",
    "Discover",
    "Saved",
    "Chat",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      //   title: Center(
      //     child: Text(
      //       _titles[_currentIndex],
      //       // textAlign: TextAlign.center,
      //       style: TextStyle(
      //           color: Colors.orange.shade800, fontWeight: FontWeight.w600),
      //     ),
      //   ),
      // ),
      // drawer: Drawer(
      //     child: ListView(
      //   padding: EdgeInsets.zero,
      //   children: const <Widget>[
      //     UserAccountsDrawerHeader(
      //       accountName: Padding(
      //         padding: EdgeInsets.only(left: 5),
      //         child: Text(""),
      //       ),
      //       accountEmail: Padding(
      //         padding: EdgeInsets.only(left: 5),
      //         child: Text(''),
      //       ),
      //       // currentAccountPicture: CircleAvatar(
      //       //   child: user.image_ref != ""
      //       //       ? UserProfileImage(imageUrl: user.image_ref)
      //       //       : ClipOval(child: Image.asset('${user.image_path}')),
      //       // ),
      //       decoration: BoxDecoration(color: Colors.amber),
      //     ),
      //   ],
      // )),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.orange,
        showUnselectedLabels: true,
        iconSize: 30,
        unselectedFontSize: 11,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        selectedFontSize: 13,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.profile_circled,
            ),
            label: 'My Closet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2_fill),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}
