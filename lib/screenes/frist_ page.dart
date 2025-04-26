import 'package:chat_app_with_firebase/Homeforscreenes.dart/User_Home_.dart';
import 'package:chat_app_with_firebase/Homeforscreenes.dart/chat_Home_.dart';
import 'package:chat_app_with_firebase/Homeforscreenes.dart/group_Home_.dart';
import 'package:chat_app_with_firebase/Homeforscreenes.dart/setting_Home_.dart';
import 'package:chat_app_with_firebase/Provider/provider.dart';
import 'package:chat_app_with_firebase/firebase/firebase_auth_.dart';
import 'package:chat_app_with_firebase/models/message_model.dart';
import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});
  

  @override
  State<FirstPage> createState() => _MyWidgetState();
} 


class _MyWidgetState extends State<FirstPage> {
  
 // @override
  
  int currentindex = 0;


   @override
    initState() 
    {
      WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<ProviderApp>(context, listen: false).GetUserDetails();
  });
  /*
     SystemChannels.lifecycle.setMessageHandler((message) {
      if(message.toString()== ' resumed'){
      FireAuth.updateLastSeen(true);

      }
      else if(message.toString() == 'passude'){
        FireAuth.updateLastSeen(false);

      }
       
       print(message);
       return Future.value(message);
     

     });
      super.initState();
    }  
    */

   SystemChannels.lifecycle.setMessageHandler((message) async {
      print("Lifecycle state: $message");
      if (message == AppLifecycleState.resumed.toString()) {
        await FireAuth.updateLastSeen(true);
      } else if (message == AppLifecycleState.paused.toString()) {
        await FireAuth.updateLastSeen(false);
      }
      return message;
    });
  }

     @override
  void dispose() {
    // Clean up lifecycle handler
    SystemChannels.lifecycle.setMessageHandler(null);
    super.dispose();
  }






  Widget build(BuildContext context) {
    List<Widget> screenes = [
      Chat_Home(),
      group_home(),
      //contacts_home(),
      ContactsHome(),

 
      setting_home(),
    ];
  
  
    //ChatUser? me = Provider.of<ProviderApp>(context).me;
    

    return Scaffold(  
       
      
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            currentindex = value;
          });
        },
        selectedIndex: currentindex,
        destinations: [
          NavigationDestination(
              icon: Icon(Icons.messenger_outline_outlined), label: 'chat'),
          NavigationDestination(
            icon: Icon(Icons.group_add_rounded),
            label: 'group',
          ),
          NavigationDestination(icon: Icon(Iconsax.user), label: 'contacts'),
          NavigationDestination(icon: Icon(Iconsax.setting_2), label: 'settin'),
        ],
      ),
      body:   screenes[currentindex],
    );
  }
} 
