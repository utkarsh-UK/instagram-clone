import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../models/user_data_provider.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static void signupUser(
      {BuildContext context,
      String username,
      String email,
      String password}) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser signedinUser = authResult.user;
      if (signedinUser != null) {
        _firestore.collection("/users").document(signedinUser.uid).setData({
          'name': username,
          'email': email,
          'profileImageUrl': '',
        });

        Provider.of<UserData>(context).currentUserId = signedinUser.uid;
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
    }
  }

  static void login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on Exception catch (e) {
      print(e);
    }
  }

  static void logout() {
    _auth.signOut();
  }
}
