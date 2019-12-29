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
    Future<QuerySnapshot> users =
        userRef.where('name', isGreaterThanOrEqualTo: name).getDocuments();

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

  static void followUser(String currentUserId, String userId) {
    // Add user to current user's following coll
    followingsRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .setData({});

    // Add current user to user's followers coll
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .setData({});
  }

  static void unfollowUser(String currentUserId, String userId) {
    // Remove user from current user's following coll
    followingsRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // Remove current user from user's followers coll
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isFollowingUser(
      {String currentUserId, String userId}) async {
    DocumentSnapshot followingDoc = await followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get();

    return followingDoc.exists;
  }

  static Future<int> numFollowing(String userId) async {
    QuerySnapshot followingSnapshot = await followingsRef
        .document(userId)
        .collection('userFollowing')
        .getDocuments();

    return followingSnapshot.documents.length;
  }

  static Future<int> numFollowers(String userId) async {
    QuerySnapshot followerSnapshot = await followersRef
        .document(userId)
        .collection('userFollowers')
        .getDocuments();

    return followerSnapshot.documents.length;
  }

  static Future<List<Post>> getFeedPosts(String userId) async {
    QuerySnapshot feedSnapshot = await feedsRef
        .document(userId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .getDocuments();

    List<Post> posts =
        feedSnapshot.documents.map((doc) => Post.fromDoc(doc)).toList();

    return posts;
  }

  static Future<User> getUserWithId(String userId) async {
    DocumentSnapshot userSnapshot = await userRef.document(userId).get();
    if (userSnapshot.exists) {
      return User.fromDoc(userSnapshot);
    }

    return User(id: null, name: null, email: null);
  }

  static Future<int> getNumberOfPosts(String userId) async {
    QuerySnapshot postNumberSnapshot = await postRef.document(userId).collection('userPosts').getDocuments();
    if (postNumberSnapshot.documents.length >= 0) {
      return postNumberSnapshot.documents.length;
    }

    return 0;
  }
}
