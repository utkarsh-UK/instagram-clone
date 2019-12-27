import 'package:flutter/material.dart';

import '../widgets/signup_form.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup-screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Instagram',
                style: TextStyle(
                  fontSize: 50.0,
                  fontFamily: 'Madame',
                ),
              ),
              SignupForm(),
            ],
          ),
        ),
      ),
    );
  }
}
