import 'package:flutter/material.dart';

import '../services/auth_services.dart';

class FeedScreen extends StatefulWidget {
  static const String routeName = '/feed-screen';

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Instagram',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Madame',
            fontSize: 40.0,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.blue,
      body: Center(
        child: FlatButton(
          child: Text('Logout'),
          onPressed: () => AuthService.logout(),
        ),
      ),
    );
  }
}
