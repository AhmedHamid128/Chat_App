import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  String? id;
  String? name;

  String? email;
  String? about;
  String? image;
  String? lastActivted;
  String? puchTokn;

  String? online;

  String? createdAt; 
  List? myUsers;
  //List<String>? myUsers;
   

  ChatUser({
    required this.id,
    required this.createdAt,
    required this.about,
    required this.email,
    required this.image,
    required this.name,
    required this.lastActivted,
    required this.online,
    required this.puchTokn,
    required this.myUsers,
     //required String lastActivated,
    
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        about: json['about'],
        email: json['email'],
        online: json['online'],
        lastActivted: json['last_activted'],
        puchTokn: json['puch_tokn'],
        createdAt: json['created_at'],
        myUsers: json['my_users'],
         
        
        );
  }
        
        
  

  // to receve it in firbase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'about': about,
      'email': email,
      'online': online,
      'last_activted': lastActivted,
      'puch_token': puchTokn,
      'created_at': createdAt,
      'my_users': myUsers,
      
        
    };
  }
/////       
  ChatUser copyWith({
    String? image,
    // ... other fields ...
  }) => ChatUser(
    image: image ?? this.image, id: '', createdAt: '', about: '', email: '', name: '', lastActivted: '', online: '', puchTokn: '', myUsers: [], 
  
    //lastActivated: '',
    // ... other fields ...
  );

}

// this class for Contacts and  search of  class UserModel {

class UserModelContacts {
  final String id;
  final String name;
  final String online;
  final String email;

  UserModelContacts({
    required this.id,
    required this.name,
    required this.online,
    required this.email,
  });

  factory UserModelContacts.fromDocument(DocumentSnapshot doc) {
    return UserModelContacts(
      id: doc.id,
      name: doc['name'] ?? '',
      online: doc['online'] ?? '',
      email: doc['email'] ?? '',
      // Fetch from Firestore
    );
  }
}

