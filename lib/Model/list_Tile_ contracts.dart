

   import 'package:chat_app_with_firebase/firebase/firebase_database.dart';
import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:chat_app_with_firebase/widegt/chat_screene.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ModelHomeContacts extends StatefulWidget {
  final ChatUser user;

  final UserModelContacts userModelContacts;

  const ModelHomeContacts(
      {super.key, required this.userModelContacts, required this.user});

  @override
  State<ModelHomeContacts> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ModelHomeContacts> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(),
      title: Text(widget.userModelContacts.name),
      subtitle:
          Text(widget.userModelContacts.online ?? 'you can chat with him'),
      trailing: IconButton(
        onPressed: () {
          List<String> memebersContacts = [
            widget.userModelContacts.id!,
            FirebaseAuth.instance.currentUser!.uid
          ]..sort(
              (a, b) => a.compareTo(b),
            );
          FireData().createRoom(widget.userModelContacts.email, context);
        
          Navigator.push(
              context,
              MaterialPageRoute( 
                  builder: (context) =>
                   ChatScreene(
                     roomId:
                       memebersContacts.toString(),
                      chatuser: widget.user,  )
                     
                      )
                      );
        },
        
        icon:const Icon(Iconsax.message),
      ),
    );
  }
}

