import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import '../utilities/constants.dart';

class DatabaseService {
  static void updateUser(User user) {
    userRef.document(user.id).updateData({
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,
    });
  }

  static Future<QuerySnapshot> searchUsers(String name) {
    Future<QuerySnapshot> users = userRef.where('name', isGreaterThanOrEqualTo: name).getDocuments();

    return users;
  }
}
