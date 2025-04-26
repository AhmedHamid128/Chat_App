




  //profile old 



/// profile old

/*
import 'dart:html' as html;
import 'dart:typed_data';


import 'package:chat_app_with_firebase/Provider/provider.dart';
import 'package:chat_app_with_firebase/firebase/firebase_database.dart';
import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';





class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool enableded1 = false;
  bool enableded2 = false;
  TextEditingController Namecon = TextEditingController();
  TextEditingController aboutcon = TextEditingController();
  ChatUser? me;


    
    
  
 
  @override
  void initState() {
    super.initState();
    final me = Provider.of<ProviderApp>(context, listen: false).me;
    Namecon.text = me!.name ?? " hhhh";
    aboutcon.text = me.about ?? "jj";
  }

  @override
  Widget build(BuildContext context) {
    final  provider = Provider.of<ProviderApp>(context);
    me ??= provider.me;  // Ensure me is initialized

  if (me == null) {
    return const Center(child: CircularProgressIndicator());
  }
     
    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: 
                       
                        () {},
                        
                           
                        icon: Icon(Iconsax.edit),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Iconsax.user_cirlce_add),
                        title: TextField(
                          controller: Namecon,
                          enabled: enableded1,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        enableded1 = true;
                      });
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Iconsax.information),
                        title: TextField(
                          controller: aboutcon,
                          enabled: enableded2,
                          decoration: const InputDecoration(
                            labelText: 'About',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        enableded2 = true;
                      });
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Card(
                child: ListTile(
                  leading: const Icon(Iconsax.direct),
                  title: const Text("Email"),
                  subtitle:  Text(me!.email!.toString()),
                ),
              ),
              const SizedBox(height: 15),
              Card(
                child: ListTile(
                  leading: const Icon(Iconsax.timer_1),
                  title: const Text("Joined at"),
                  subtitle:  Text(me!.createdAt!.toString()),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(450, 50),
                   backgroundColor: Color(provider.mainColor), 
                 // backgroundColor: Colors.green[400],
              
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.black),
                ),
              ),  
            ],
          ),
        ),
      ),
    );
  }
}
*/



    // profile is correct 


    import 'dart:typed_data';

import 'package:chat_app_with_firebase/Provider/provider.dart';
import 'package:chat_app_with_firebase/firebase/firebase_database.dart';

import 'package:chat_app_with_firebase/firebase/firebase_storage.dart';
 
import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
   

  bool nameEdit = false;
  bool aboutEdit = false;
  TextEditingController Namecon = TextEditingController();
  TextEditingController aboutcon = TextEditingController();
  ChatUser? me;
  

  
  Uint8List? selectedImage; // To store the selected image bytes

  @override
  void initState() {
    super.initState();
    final me = Provider.of<ProviderApp>(context, listen: false).me;
    Namecon.text = me!.name ?? " hhhh";
    aboutcon.text = me.about ?? "jj";
  }


  // Function to upload the image to Firebase Storage and return the download URL
  
  Future<String> uploadProfileImage(Uint8List imageBytes) async {
   
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('profilePictures/${me!.id}.jpg');
    await imageRef.putData(imageBytes);
    final url = await imageRef.getDownloadURL();
    return url;
  }





  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderApp>(context);
    me ??= provider.me; // Ensure me is initialized

    if (me == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: 
          
          Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      
                      radius: 70,
                      backgroundImage: selectedImage != null
                          ? MemoryImage(selectedImage!) // Show selected image
                          : (me!.image != null && me!.image!.isNotEmpty
                              ? NetworkImage(me!.image!) // Show current profile image
                              : null), // No image if none exists
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () async {
                          // Open file picker to select an image
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            final bytes = await pickedFile.readAsBytes();
                            setState(() {
                              selectedImage = bytes; // Update UI with selected image
                            });
                          }
                        },
                        icon: const Icon(Iconsax.edit),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Iconsax.user_cirlce_add),
                        title: TextField(
                          controller: Namecon,
                          enabled: nameEdit,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        nameEdit = true;
                      });
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Iconsax.information),
                        title: TextField(
                          controller: aboutcon,
                          enabled: aboutEdit,
                          decoration: const InputDecoration(
                            labelText: 'About',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        aboutEdit=  true;
                      });
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Card(
                child: ListTile(
                  leading: const Icon(Iconsax.direct),
                  title: const Text("Email"),
                  subtitle: Text(me!.email!.toString()),
                ),
              ),
              const SizedBox(height: 15),
              Card(
                child: ListTile(
                  leading: const Icon(Iconsax.timer_1),
                  title: const Text("Joined at"),
                  subtitle: Text(
                   
                    
                 me!.createdAt!,
                

                      ),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(450, 50),
                  backgroundColor: Color(provider.mainColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
               
                onPressed: () async {
                  FireData().editProfile(Namecon.text, aboutcon.text).then((value){
                    setState(() {
                       nameEdit = false;
                    aboutEdit =false;
                      
                    });
                   

                  });
                 },


             
                 
                
                  // Show loading indicator 
                  /*
                  showDialog(
                    context: context,
                    builder: (context) => const Center(child: CircularProgressIndicator()),
                  );

                  try {
                    String? imageUrl;
                    if (selectedImage != null) {
                      // Upload the image if a new one was selected
                      imageUrl = await uploadProfileImage(selectedImage!);
                    }

                    // Update the local ChatUser object
                    me!.name = Namecon.text;
                    me!.about = aboutcon.text;
                    if (imageUrl != null) {
                      me!.image = imageUrl; // Update image URL if uploaded
                    }

                    // Save updated user info to Firebase Database
                    await FireStorage.updateUserInfo(me!);

                    // Update the provider to reflect changes app-wide
                    final provider = Provider.of<ProviderApp>(context, listen: false);
                    provider.me = me;
                    provider.notifyListeners();

                    // Hide loading indicator
                    Navigator.pop(context);

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully')),
                    );

                    // Reset selected image
                    setState(() {
                      selectedImage = null;
                    });
                  } catch (e) {
                    // Hide loading indicator
                    Navigator.pop(context);

                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error updating profile: $e')),
                    );
                  }
                },
                */
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// 


