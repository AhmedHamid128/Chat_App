

   import 'package:chat_app_with_firebase/firebase/firebase_database.dart';
import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:chat_app_with_firebase/widegt/ChatScreen2.dart';
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
          Text(widget.userModelContacts.online ?? " You can Chat with  him "),
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
        
        icon: Icon(Iconsax.message),
      ),
    );
  }
}


/*
import 'package:chat_app_with_firebase/Homeforscreenes.dart/User_Home_.dart';
import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Home_Contract extends StatefulWidget {
  final ChatUser user;
  final UserModelContacts usermodelcontacts;
  const Home_Contract({super.key, required this.user, required this.usermodelcontacts}) {
   

  @override
  State<Home_Contract> createState() => _Contract_HomeState();
}

class _Contract_HomeState extends State<Home_Contract> {
  TextEditingController emailcon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                //contacts_home()
                ContactsHome(),
          )),
      leading: CircleAvatar(),
      title: Text(widget.user.name!),
      subtitle: Text(widget.user.about!),
      trailing: IconButton(
        onPressed: () {
          /*
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreene(
                      roomId: '',
                      // قيم افتراضيه
                      chatuser: ChatUser(
                        id: '',
                        createdAt: '',
                        about: '',
                        email: '',
                        image: '',
                        name: '',
                        lastActivted: '',
                        online: '',
                        puchTokn: '',
                        myUsers: [],
                      ),
                    )),
          );
          */
        },
        icon: Icon(Iconsax.message),
      ),
    );
  }
}

*/