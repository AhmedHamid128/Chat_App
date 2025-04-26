

import 'dart:typed_data';

import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';


class FireStorage {
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




//void main() => runApp(MaterialApp(home: ImagePickerScreen()));

/*
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


void openpicker() async {
  FilePickerResult? resulat;
  resulat = await FilePicker.platform
      .pickFiles(type: FileType.custom, allowedExtensions: ['png', 'jpg']);
  if (resulat != null) {
    Uint8List? uploadfile = resulat.files.single.bytes;
    String Filename = resulat.files.single.name;
    Reference reference = FirebaseStorage.instance.ref().child(Uuid().v1());

    final UploadTask uploadTask = reference.putData(uploadfile!);
    String image = await uploadTask.snapshot.ref.getDownloadURL();
    print(image);
  }
}
*/
/*
Future<void> uploadImage(File image, String uid, String roomId) async {
  
  try {
    // Create a reference to Firebase Storage
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    // Upload the file
    Uint8List? imageBytes;

    if (kIsWeb) {
      imageBytes = await image.readAsBytes(); // Web-friendly
      await storageRef.putData(imageBytes); // Use putData for Uint8List
    } else {
      File imageFile = File(image.path);
      await storageRef.putFile(imageFile); // Use putFile for other platforms
    }

    // Get the download URL
    final imageUrl = await storageRef.getDownloadURL();

    // Send the image as a message
    await FireData().sendMessage(uid, imageUrl, roomId, type: 'image');

    //await FireData().sendMessage(uid, imageUrl, roomId, type: 'image');

    print('Image uploaded: $imageUrl');
  } catch (e) {
    print('');
  }
}
*/