import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:instagram_clone/utilities/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static Future<String> uploadUserProfileImage(
      String url, File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imageFile);

    if (url.isNotEmpty) {
      // Updating the profile image
      RegExp regExp = RegExp(r'userProfile_(.*).jpg');
      photoId = regExp.firstMatch(url)[1];
    }

    StorageUploadTask storageUploadTask =
        storage.child('images/users/userProfile_$photoId.jpg').putFile(image);
    StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  static Future<File> compressImage(String photoId, File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    File compressedImage = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/image_$photoId.jpg',
      quality: 70,
    );

    return compressedImage;
  }
}
