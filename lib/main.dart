import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/feed_screen.dart';
import './screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget getScreenRoute() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (ctx, snapshot) => snapshot.hasData
          ? HomeScreen(
              userId: snapshot.data.uid,
            )
          : LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryIconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.black,
            ),
      ),
      home: getScreenRoute(),
      routes: {
        LoginScreen.routeName: (_) => LoginScreen(),
        SignupScreen.routeName: (_) => SignupScreen(),
        FeedScreen.routeName: (_) => FeedScreen(),
      },
    );
  }
}
