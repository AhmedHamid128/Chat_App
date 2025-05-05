

import 'package:chat_app_with_firebase/Model/list_Tile_%20contracts.dart';
import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';

class ContactsHome extends StatefulWidget {
  const ContactsHome({super.key});

  @override
  State<ContactsHome> createState() => _ContactsHomeState();
}

class _ContactsHomeState extends State<ContactsHome> {
  bool isSearching = false;
  List<String> myContacts = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchController.clear();
      }
    });
  }

  void addContact() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Enter Your Friend\'s Email'),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                    },
                    icon: const Icon(Iconsax.scan4),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(FontAwesomeIcons.envelope),
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    backgroundColor: const Color.fromARGB(255, 40, 119, 66),
                  ),
                  onPressed: () async {
                    if (emailController.text.isNotEmpty) {
                      await addContactByEmail(emailController.text);
                      emailController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Add Contact',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> addContactByEmail(String email) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (result.docs.isNotEmpty) {
        final String friendId = result.docs.first.id;
        final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .update({
          'my_users': FieldValue.arrayUnion([friendId])
        });

        setState(() {
          myContacts.add(friendId);
        });
      } else {
       
      }
    } catch (e) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: isSearching
              ? TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search by name',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                )
              : const Text('My Contacts'),
          actions: [
            IconButton(
              onPressed: toggleSearch,
              icon: Icon(isSearching ? Icons.cancel : Icons.search),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addContact,
          child: const Icon(
            Iconsax.user_add,
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    myContacts = List<String>.from(
                        snapshot.data!.data()!['my_users'] ?? []);

                    if (myContacts.isEmpty) {
                      return const Center(child: Text('No contacts found.'));
                    }

                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where(FieldPath.documentId, whereIn: myContacts)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final users = snapshot.data!.docs
                              .map((doc) => UserModelContacts.fromDocument(doc))
                              .where((user) => user.name.toLowerCase().contains(
                                  searchController.text.toLowerCase()))
                              .toList();

                          return ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              return ModelHomeContacts(
                                userModelContacts: users[index],
                                // قيم افتراضيه
                                user: ChatUser(
                                    id: "",
                                    createdAt: "",
                                    about: "",
                                    email: "",
                                    image: "",
                                    name: "",
                                    lastActivted: "",
                                    online: "",
                                    puchTokn: "",
                                    myUsers: [""], 
                                   
                                    ),
                              );
                              
                            },
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ));
  }
}


    