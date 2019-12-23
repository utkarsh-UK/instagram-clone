import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/user_data_provider.dart';
import '../services/stoarage_services.dart';
import '../services/database_services.dart';
import '../models/post_model.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File _image;
  TextEditingController _captionController = TextEditingController();
  String _caption = '';
  var _isLoading = false;

  _showImageDialog() {
    return Platform.isIOS
        ? _buildCupertinoBottomSheet()
        : _buildAndroidDialog();
  }

  _buildCupertinoBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text('Add Photo'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text('Take Image'),
            onPressed: () => _handleImage(ImageSource.camera),
          ),
          CupertinoActionSheetAction(
            child: Text('Choose from gallery'),
            onPressed: () => _handleImage(ImageSource.gallery),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(ctx).pop(),
        ),
      ),
    );
  }

  _buildAndroidDialog() {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text('Add a Photo'),
        children: <Widget>[
          SimpleDialogOption(
            child: Text('Take Photo'),
            onPressed: () => _handleImage(ImageSource.camera),
          ),
          SimpleDialogOption(
            child: Text('Choose From Gallery'),
            onPressed: () => _handleImage(ImageSource.gallery),
          ),
          SimpleDialogOption(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  _handleImage(ImageSource imageSource) async {
    File imageFile = await ImagePicker.pickImage(source: imageSource);
    if (imageFile != null) {
      imageFile = await _cropImage(imageFile);
      setState(() {
        _image = imageFile;
      });
    }
    Navigator.of(context).pop();
  }

  _cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(
        ratioX: 1.0,
        ratioY: 1.0,
      ),
    );

    return croppedImage;
  }

  Future<void> _submit() async {
    if (!_isLoading && _image != null && _caption.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
    }

    String imageUrl = await StorageService.uploadPost(_image);
    Post post = Post(
      caption: _caption,
      imageUrl: imageUrl,
      authorId: Provider.of<UserData>(context).currentUserId,
      likes: {},
      timestamp: Timestamp.fromDate(
        DateTime.now(),
      ),
    );
    DatabaseService.createPost(post);

    _captionController.clear();
    setState(() {
      _caption = '';
      _image = null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Create Post',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _submit,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            height: height,
            child: Column(
              children: <Widget>[
                _isLoading
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.blue[200],
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ),
                      )
                    : SizedBox.shrink(),
                GestureDetector(
                  onTap: _showImageDialog,
                  child: Container(
                    height: width,
                    width: width,
                    color: Colors.grey,
                    child: _image == null
                        ? Icon(
                            Icons.add_a_photo,
                            size: 150.0,
                            color: Colors.white70,
                          )
                        : Image(
                            image: FileImage(_image),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    controller: _captionController,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Caption',
                    ),
                    onChanged: (input) => _caption = input,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
