import 'package:fashion_app/providers/userProvider.dart';
import 'package:fashion_app/screens/navigation/ChatPage.dart';
import 'package:fashion_app/screens/navigation/DiscoverPage.dart';
import 'package:fashion_app/screens/navigation/GroupsPage.dart';
import 'package:fashion_app/screens/navigation/MyClosetPage.dart';
import 'package:fashion_app/screens/navigation/SavedPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
