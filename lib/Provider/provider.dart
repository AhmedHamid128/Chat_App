


import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProviderApp with ChangeNotifier {


   int mainColor = 0xff405085;
  ThemeMode themeMode = ThemeMode.system;
  ChatUser?  me ;
    // use initi to late data to get the least of data from firebase
  ProviderApp() {
    _initializeUserDetails();
  }

  Future<void> _initializeUserDetails() async {
    await GetUserDetails(); 
  }
  

    void ChanageMode(bool dark)async {
     
    themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    
    notifyListeners();
    }
    void ChanageColor(int valueofColor) async{
       
      mainColor =valueofColor;
      
      notifyListeners();

    }
    /*
    Future<void> GetUserDetiales() async{
      String myId = FirebaseAuth.instance.currentUser!.uid;
      // Store my data in me and apear from json
     await FirebaseFirestore.instance.collection('users').doc(myId).get().then((value)=> me = ChatUser.fromJson(value.data()!),);
     notifyListeners();
    }
    */



    Future<void> GetUserDetails() async {
    String myId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(myId).get();
    me = ChatUser.fromJson(userDoc.data() as Map<String, dynamic>);
    notifyListeners();
  }

  //
  
  
}