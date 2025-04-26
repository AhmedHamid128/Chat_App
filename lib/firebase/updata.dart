
/*
// lib/firebase/firebase_database.dart
// ignore: depend_on_referenced_packages
import 'package:firebase_database/firebase_database.dart';
import 'package:chat_app_with_firebase/models/user_model.dart';

class APIs {
  static final DatabaseReference users= FirebaseDatabase.instance.ref();

  // Update user information in Firebase Realtime Database
  static Future<void> updateUserInfo(ChatUser user) async {
    try {
      await users.child('users').child(user.id!).update({
        'name': user.name,
        'about': user.about,
        'image': user.image,
        // Add other fields as needed
      });
    } catch (e) {
      rethrow; // Propagate the error for handling in the calling code
    }
  }
}
*/