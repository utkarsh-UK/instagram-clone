import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/activity_screen.dart';
import '../screens/create_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
import '../models/user_data_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndexTab = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserData>(context, listen: false).currentUserId;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          FeedScreen(),
          SearchScreen(),
          CreatePostScreen(),
          ActivityScreen(),
          ProfileScreen(
            userId: userId,
          ),
        ],
        onPageChanged: (index) => setState(() {
          _currentIndexTab = index;
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        currentIndex: _currentIndexTab,
        selectedItemColor: Colors.black,
        iconSize: 30.0,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndexTab = index;
            _pageController.animateToPage(
              index,
              duration: Duration(
                milliseconds: 600,
              ),
              curve: Curves.easeIn,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
            ),
            title: Text('Photo'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
            ),
            title: Text('Notifications'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
            ),
            title: Text('Account'),
          ),
        ],
      ),
    );
  }
}
