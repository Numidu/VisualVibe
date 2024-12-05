import 'package:flutter/material.dart';
import 'package:socially/service/auth/auth_srvice.dart';
import 'package:socially/views/mainscreen/create_screnn.dart';
import 'package:socially/views/mainscreen/feed_screen.dart';
import 'package:socially/views/mainscreen/profile_screen.dart';
import 'package:socially/views/mainscreen/reels_screen.dart';
import 'package:socially/views/mainscreen/search_screen.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int index = 0;

  final List<Widget> screens = [
    FeedScreen(),
    SearchScreen(),
    CreateScrenn(),
    ProfileScreen(),
  ];
  void onItemTapped(int indexs) {
    setState(() {
      index = indexs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              label: "search"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle_outline,
              ),
              label: "Create"),
          // BottomNavigationBarItem(
          //     icon: Icon(
          //       Icons.video_library,
          //     ),
          //     label: "Reels"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: "profile"),
        ],
        currentIndex: index,
        onTap: onItemTapped,
      ),
      body: screens[index],
    );
  }
}
