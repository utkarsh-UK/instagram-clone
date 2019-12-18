import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/database_services.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _bio = '';

  @override
  void initState() {
    super.initState();

    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // Update user in database
      String _profileImageUrl = '';
      User user = User(
        id: widget.user.id,
        name: _name,
        bio: _bio,
        profileImageUrl: _profileImageUrl,
        email: widget.user.email,
      );

      DatabaseService.updateUser(user);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTNDW8nWT75P2ZL60rS4ZAmcVE0Oa73bDG4JNbsVTiIzAt96Z2C'),
                  ),
                  FlatButton(
                    child: Text(
                      'Change Profile Image',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 16.0,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  TextFormField(
                    initialValue: _name,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        size: 30.0,
                      ),
                      labelText: 'Name',
                    ),
                    validator: (input) => input.trim().length < 1
                        ? 'Please, enter a valid name'
                        : null,
                    onSaved: (input) => _name = input,
                  ),
                  TextFormField(
                    initialValue: _bio,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.book,
                        size: 30.0,
                      ),
                      labelText: 'Bio',
                    ),
                    validator: (input) => input.trim().length > 150
                        ? 'Please, enter a bio less than 150 char'
                        : null,
                    onSaved: (input) => _bio = input,
                  ),
                  Container(
                    margin: const EdgeInsets.all(40.0),
                    height: 40.0,
                    width: 250,
                    child: FlatButton(
                      child: Text(
                        'Save Profile',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      color: Colors.blue,
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
