import 'dart:async';
import 'dart:typed_data';

import 'package:chat_app_with_firebase/Provider/provider.dart';
import 'package:chat_app_with_firebase/models/Group-model.dart';
import 'package:chat_app_with_firebase/models/Room_model.dart';
import 'package:chat_app_with_firebase/models/message_model.dart';
import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

/*
 final String myid = FirebaseAuth.instance.currentUser!.uid;
 void createRoom1(String email) async {
  try {
    await FirebaseFirestore.instance.collection('rooms').add({
      'email': email,
      ' whon created chat id =': myid,
      'created_at': Timestamp.now(),
      ' last_Message_Time': Timestamp.now(), 
    });
    print("Room created successfully!");
  } catch (e) {
    print("Failed to create room: $e");
  }
}
*/
class FireData {
  //
  ChatUser? me;
  final FirebaseFirestore firestor = FirebaseFirestore.instance;
  final String myid = FirebaseAuth.instance.currentUser!.uid;
  // model for  DateTime.
  String time = DateTime.now().millisecondsSinceEpoch.toString();

   

   Future createRoom(String email, BuildContext context) async {
  
    //البحث عن المستخدم بالبريد الإلكتروني
    QuerySnapshot useremail = await firestor
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

// إذا وُجد المستخدم
    if (useremail.docs.isNotEmpty) {
      String userId = useremail.docs.first.id;
      //إنشاء قائمة الأعضاء وترتيبها
      List<String> memberslist = [myid, userId]..sort(
          (a, b) => a.compareTo(b),
        );

      // if there are room Already available
      QuerySnapshot roomexit = await firestor
          .collection('Room')
          .where('members', isEqualTo: memberslist)
          .get();
      if (roomexit.docs.isEmpty) {
        ChatRoom chatRoom = ChatRoom(
            id: memberslist.toString(),
            members: memberslist,
            lastMessage: '',
            createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
            lastMesssageTime: DateTime.now().toString());
        await firestor
            .collection('Room')
            .doc(memberslist.toString())
            .set(chatRoom.toJson());
        print("Room created successfully!");
        /// TODO
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: Color.fromARGB(255, 30, 60, 42),
            content: Center(
              child: Text(
                "Create chat successfully!",
                style: TextStyle(color: Colors.white),
              ),
            ),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Room already exists
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: Color.fromARGB(255, 30, 60, 42),
            content: Center(
              child: Text(
                //"ليك كلام قبل كده معاه",
                "Room already exists.",
                style: TextStyle(color: Colors.white),
              ),
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      // User not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Color.fromARGB(255, 30, 60, 42),
          content: Center(
            child: Text(
              "User not found.",
              style: TextStyle(color: Colors.white),
            ),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future addContact(String email) async {
    QuerySnapshot useremail = await firestor
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (useremail.docs.isNotEmpty) {
      String userId = useremail.docs.first.id;

      firestor.collection('users').doc(myid).update({
        'my_users': FieldValue.arrayUnion([
          userId
        ]), // use array type of arrayUnion to مما يضمن عدم وجود تكرارات
      });
    }
  }

// تأخذ هذه الدالة uid (معرف المستلم)، msg (نص الرسالة)، roomId (معرف الغرفة)، ونوع اختياري type
  Future sendMessage(String uid, String msg, String roomId,
      {String? type}) async {
    // create varabiale unique for each message use  Uuid().v1()
    String MesId = Uuid().v1();
    Message message = Message(
        id: MesId,
        ToId: uid,
        FromId: myid,
        msg: msg,
        type: type ?? 'text',
        read: '',
        createdAt: DateTime.now().millisecondsSinceEpoch.toString());
    // حفظ الرسالة في Firesbase
    await firestor
        .collection('Room')
        .doc(roomId)
        .collection('Messages')
        .doc(MesId)
        .set(message.toJson());

    firestor.collection('Room').doc(roomId).update({
      'last_message': type ?? msg,
      'last_time_message': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  Future readMessage(String roomId, String MesId) async {
    await firestor
        .collection('Room')
        .doc(roomId)
        .collection('Messages')
        .doc(MesId)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }
/*
  Future DeletMsaage(String roomId, List Msges) async {
    for (var element in Msges) {
      await firestor
          .collection('Room')
          .doc(roomId)
          .collection('Messages')
          .doc(element)
          .delete();
    }
  }
*/

  Future<void> DeletMsaage(String roomId, List selectedMessages) async {
    // Delete selected messages
    for (var element in selectedMessages) {
      await FirebaseFirestore.instance
          .collection('Room')
          .doc(roomId)
          .collection('Messages')
          .doc(element)
          .delete();
    }

    // Fetch the latest message after deletion to update the chat room's last message
    final messagesSnapshot = await FirebaseFirestore.instance
        .collection('Room')
        .doc(roomId)
        .collection('Messages')
        .orderBy('createdAt',
            descending: true) // means order تنازالي للحصول  علي  احدث رساله
        .limit(1)
        .get(GetOptions(source: Source.server));

    // Check if there's a new last message
    if (messagesSnapshot.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('Room').doc(roomId).update({
        'lastMessage': '',
        'lastMesssageTime': '',
      });
    } else {
      // No messages left in the room, so set the last message to an empty string
      await FirebaseFirestore.instance.collection('Room').doc(roomId).update({
        'lastMessage': '',
        'lastMesssageTime': '',
      });
    }
  }

  Future creatGroup(String groupName, List members) async {
    String groupId = Uuid().v1();
    // I m include in members
    members.add(myid);
    ChatUsersGroup chatUsersGroup = ChatUsersGroup(
        id: groupId,
        name: groupName,
        admin: [myid],
        members: members,
        about: "اهلا بيك بس بلاش تعمل دوشه علشان مصدع.",
        image: "",
        createdAt: time,
        lastMessage: "",
        lastMessageTime: time);

    await firestor.collection('Group').doc(groupId).set(
          chatUsersGroup.toJson(),
        );
  }
  //

  Future sendGroupMessage(String msg, String roomId, {String? type}) async {
    // create varabiale unique for each message use  Uuid().v1()
    String MesId = Uuid().v1();
    Message message = Message(
        id: MesId,
        ToId: "",
        FromId: myid,
        msg: msg,
        type: type ?? 'text',
        read: '',
        createdAt: DateTime.now().millisecondsSinceEpoch.toString());
    // حفظ الرسالة في Firesbase
    await firestor
        .collection('Group')
        .doc(roomId)
        .collection('Messages')
        .doc(MesId)
        .set(message.toJson());

    firestor.collection('Group').doc(roomId).update({
      'last_message': type ?? msg,
      'last_message_time': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  Future editGroup(String groupId, String name, List members) async {
    await firestor
        .collection('Group')
        .doc(groupId)
        .update({'name': name, 'members': FieldValue.arrayUnion(members)});
  }

/// 
/// 
/// 
/// 


  /*
Future editProfile(String name, String about, {Uint8List? imageBytes})  async{
  await firestor.collection('users').doc(myid).update({'name':name,'about':about,});

}
*/

Future editProfile(String name, String about, {String? imageUrl}) async {
  Map<String, dynamic> updateData = {'name': name, 'about': about};
  if (imageUrl != null) {
    updateData['image'] = imageUrl; // Add image URL to update if provided
  }
  await firestor.collection('users').doc(myid).update(updateData);
}

}






