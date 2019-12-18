import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_model.dart';
import '../services/database_services.dart';
import '../services/stoarage_services.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File _profileImage;
  String _name = '';
  String _bio = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  Future<File> _handleImageFromGallery() async {
    File _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_imageFile != null) {
      setState(() {
        _profileImage = _imageFile;
      });
    }
  }

  _displayProfileImage() {
    if (_profileImage == null) {
      // No profile image
      if (widget.user.profileImageUrl.isEmpty) {
        return AssetImage('assets/images/user_profile_placeholder.png');
      } else {
        return CachedNetworkImageProvider(
          widget.user.profileImageUrl,
        );
      }
    } else {
      // New profile image
      return FileImage(_profileImage);
    }
  }

  void _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });
      // Update user in database
      String _profileImageUrl = '';

      if (_profileImage == null) {
        _profileImageUrl = widget.user.profileImageUrl;
      } else {
        _profileImageUrl = await StorageService.uploadUserProfileImage(
            widget.user.profileImageUrl, _profileImage);
      }

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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            _isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  )
                : SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 60.0,
                      backgroundImage: _displayProfileImage(),
                    ),
                    FlatButton(
                      child: Text(
                        'Change Profile Image',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 16.0,
                        ),
                      ),
                      onPressed: _handleImageFromGallery,
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
          ],
        ),
      ),
    );
  }
}
