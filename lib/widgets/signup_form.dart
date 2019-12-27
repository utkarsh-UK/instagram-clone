import 'package:flutter/material.dart';

import '../services/auth_services.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _password;

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // Signing up user
      AuthService.signupUser(
        context: context,
        username: _name,
        email: _email,
        password: _password,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 10.0,
            ),
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Username'),
              validator: (input) => input.trim().isEmpty
                  ? 'Please enter a unique username'
                  : null,
              onSaved: (input) => _name = input,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 10.0,
            ),
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              validator: (input) =>
                  !input.contains('@') ? 'Please enter a valid email' : null,
              onSaved: (input) => _email = input,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 10.0,
            ),
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (input) => input.length < 8
                  ? 'Password must be at least 6 characters.'
                  : null,
              onSaved: (input) => _password = input,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: 250.0,
            child: FlatButton(
              child: Text(
                'Signup',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              color: Colors.blue,
              padding: const EdgeInsets.all(10.0),
              onPressed: _submit,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: 250.0,
            child: FlatButton(
              child: Text(
                'Go to Login',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              color: Colors.blue,
              padding: const EdgeInsets.all(10.0),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
