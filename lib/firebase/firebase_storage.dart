



import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
class FireStorage {
  static final DatabaseReference users= FirebaseDatabase.instance.ref();

  // Update user information in Firebase Realtime Database
  static Future<void> updateUserInfo(ChatUser user) async {
    try {
      await users.child('users').child(user.id!).update({
        'name': user.name,
        'about': user.about,
        'image': user.image,
       
      });
    } catch (e) {
      rethrow;
       // Propagate the error for handling in the calling code
    }
  }



}



