import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = Firestore.instance;

final userRef = _firestore.collection('users');
final storage = FirebaseStorage.instance.ref();
final postRef = _firestore.collection('posts');