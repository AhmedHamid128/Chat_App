import 'package:chat_app_with_firebase/Provider/provider.dart';
import 'package:chat_app_with_firebase/Setting/Q_R_code.dart';
import 'package:chat_app_with_firebase/Setting/profile.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';



class setting_home extends StatefulWidget {
  
  const setting_home({super.key});

  @override
  State<setting_home> createState() => _settin_homeState();
}

class _settin_homeState extends State<setting_home> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderApp>(context);
    return Scaffold(
      
      floatingActionButton: FloatingActionButton (onPressed: (){
        FirebaseMessaging.instance.requestPermission();
        FirebaseMessaging.instance.getToken().then((value){
       

        });

      }),


      appBar: AppBar(
        title:const Text('setting'),
      ),
      body: Padding(
        padding:const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                minVerticalPadding: 40,
                leading:const CircleAvatar(
                  radius: 60,  
                ),
                title:  Text(provider.me?.name ??  'jjj' ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRCode(),
                      ),
                    );
                  },
                  icon:const Icon(Iconsax.scan),
                ),
              ),
             const SizedBox(
                height: 10,
              ),
              Card(
                child: ListTile(
                  leading:const Icon(Iconsax.user),
                  title: Text('Profile'),
                  trailing: Icon(Iconsax.arrow_right),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Profile
                              //Profile

                              ())),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: SingleChildScrollView(
                              child: BlockPicker(
                                  pickerColor: 
                                  
                                  Colors.red,
                                  onColorChanged: (Value) {
                                    
                                    provider.ChanageColor(Value.value);

                                  },),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('done'))
                            ],
                          );
                        });
                  },
                  leading: Icon(Icons.color_lens),
                  title: Text('Theme'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Iconsax.user),
                  title: Text('Dark mode'),
                  trailing: Switch(value: provider.themeMode== ThemeMode.dark, onChanged: (Value) {

              provider.ChanageMode(Value);
                  },
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () async => await FirebaseAuth.instance.signOut(),
                  leading:const Icon(Iconsax.user),
                  title: const Text('Signout'),
                  trailing:const Icon(Icons.logout),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
