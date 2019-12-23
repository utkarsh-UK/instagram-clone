import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import '../utilities/constants.dart';
import '../models/post_model.dart';

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

  static void createPost(Post post) {
    postRef.document(post.authorId).collection('userPosts').add({
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      'likes': post.likes,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    });
  }
}
