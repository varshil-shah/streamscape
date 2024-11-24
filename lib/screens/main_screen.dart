import 'package:flutter/material.dart';
import 'package:streamscape/routes.dart';
import 'package:streamscape/screens/my_videos_screen.dart';
import 'package:streamscape/screens/home_screen.dart';
import 'package:streamscape/screens/profile_screen.dart';
import 'package:streamscape/screens/upload_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    HomeScreen(),
    const UploadScreen(),
    const MyVideosScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("StreamScape"),
        leading: Image.asset(
          'assets/icons/logo.png',
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // testing purpose
              Navigator.pushNamed(context, Routes.video);
            },
          ),
          Hero(
            tag: 'searchBar',
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.search);
              },
              icon: const Icon(Icons.search),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: _screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'My videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
