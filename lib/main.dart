import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/feed_screen.dart';
import './screens/home_screen.dart';
import './screens/profile_screen.dart';
import './models/user_data_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget getScreenRoute() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          Provider.of<UserData>(ctx).currentUserId = snapshot.data.uid;
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => UserData(),
      child: MaterialApp(
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
          ProfileScreen.routeName: (_) => ProfileScreen(),
        },
      ),
    );
  }
}
