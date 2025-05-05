

import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FireAuth {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static User user = auth.currentUser!;

  static Future creatuser() async {
    await auth.currentUser!.reload(); 
    user = auth.currentUser!;

    final dateFormat = DateFormat('yyyy-MM-dd');
      final createdAt = dateFormat.format(DateTime.now());
      
    ChatUser chatUser = ChatUser( 
      id: user.uid,
      createdAt: createdAt,
      about: 'Im Ahmed Hamid',
      email: user.email ?? '',
      name: user.displayName ?? 'No name',
      image: '',
      lastActivted:DateTime.now().millisecondsSinceEpoch.toString(),
      puchTokn: '',
      online: false.toString(),
      myUsers: [], 
      
    );
    try {
      if (user != null) {
        // تأكد من وجود مستخدم مسجل الدخول
        await firebaseFirestore
            .collection('users')
            .doc(user.uid)
            .set(chatUser.toJson());

        print("User created successfully!");
      } else {
        print("No user logged in!");
      }
    } catch (e) {
      print("Failed to create user: $e"); 
    }
    //this  special for contacts
    UserModelContacts userModelContacts = UserModelContacts(
      id: user.uid,
      name: user.displayName ?? 'No name',
      online: false.toString(),
      email: "",
    );



  }

     static Future updateLastSeen(bool online) async {
    try {
      if (user == null) {
        print("No user logged in!");
        return;
      }
      await firebaseFirestore.collection('users').doc(user!.uid).update({
        'online': online.toString(),
        'last_activted': DateTime.now().millisecondsSinceEpoch.toString(),
      });
     print("Last seen updated successfully!");
    } catch (e) {
      print("Failed to update last seen: $e");
    }
  } 


}