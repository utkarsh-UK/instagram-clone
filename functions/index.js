const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.onFollowUser = functions.firestore
  .document("/followers/{user_id}/userFollowers/{follower_id}")
  .onCreate(async (snapshot, context) => {
    const userId = context.params.user_id;
    const followerId = context.params.follower_id;

    const followedUserPostsRef = admin
      .firestore()
      .collection("posts")
      .doc(userId)
      .collection("userPosts");

    const userFeedRef = admin
      .firestore()
      .collection("feeds")
      .doc(followerId)
      .collection("userFeed");

    const followedUserPostsSnapshot = await followedUserPostsRef.get();
    followedUserPostsSnapshot.forEach(doc => {
      if (doc.exists) {
        userFeedRef.doc(doc.id).set(doc.data());
      }
    });
  });

exports.onUnfollowUser = functions.firestore
  .document("/followers/{user_id}/userFollowers/{follower_id}")
  .onDelete(async (snapshot, context) => {
    const userId = context.params.user_id;
    const followerId = context.params.follower_id;

    const userFeedRef = admin
      .firestore()
      .collection("feeds")
      .doc(followerId)
      .collection("userFeed")
      .where("authorId", "==", userId);

    const userPostsSnapshot = await userFeedRef.get();
    userPostsSnapshot.forEach(doc => {
      if (doc.exists) {
        doc.ref.delete();
      }
    });
  });

exports.onUploadPost = functions.firestore
  .document("/posts/{user_id}/userPosts/{post_id}")
  .onCreate(async (snapshot, context) => {
    const userId = context.params.user_id;
    const postId = context.params.post_id;

    const userFollowersRef = admin
      .firestore()
      .collection("followers")
      .doc(userId)
      .collection("userFollowers");
    const userFollowerSnapshot = await userFollowersRef.get();
    userFollowerSnapshot.forEach(doc => {
      admin
        .firestore()
        .collection("feeds")
        .doc(doc.id)
        .collection("userFeed")
        .doc(postId)
        .set(snapshot.data());
    });
  });
