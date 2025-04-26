/*
import 'package:chat_app_with_firebase/models/Group-model.dart';
import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EditGroupScreen extends StatefulWidget {
  final ChatUsersGroup chatUsersGroup;
  const EditGroupScreen({super.key, required this.chatUsersGroup});

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  TextEditingController gNameCon = TextEditingController();
  final String myId = FirebaseAuth.instance.currentUser!.uid;
  List<String> members = [];
  
  List<String> myContacts = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    gNameCon.text = widget.chatUsersGroup.name.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: Text("Done"),
          icon: Icon(Iconsax.tick_circle),
        ),
        appBar: AppBar(
          title: Text("Edit Group"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(' Enter a New  Name of Group'),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 40,
                        ),
                        Positioned(
                            bottom: -10,
                            right: -10,
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.add_a_photo)))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: gNameCon,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.4, // Takes 40% of screen
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
                            return Center(child: Text('No contacts found.'));
                          }

                          return StreamBuilder
                              //<QuerySnapshot>
                              (
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .where(FieldPath.documentId,
                                    whereIn: myContacts)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final users = snapshot.data!.docs
                                    .map((doc) =>
                                        UserModelContacts.fromDocument(doc))
                                    // means Remove myname from members
                                    .where((Element) => Element.id != myId)
                                    .toList();

                                return ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (context, index) {
                                    final isSelected =
                                        members.contains(users[index].id);
                                    return CheckboxListTile(
                                      checkboxShape: CircleBorder(),
                                      value: isSelected,
                                      onChanged: (bool? value) {
                                        setState(() {});
                                        (() {
                                          if (value == true) {
                                            members.add(users[index].id!);
                                          } else {
                                            members.remove(users[index].id!);
                                          }
                                        });
                                      },
                                      title: Text(users[index].name),
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Divider(),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text("Add Members"),
                  Spacer(),
                  Text("0"),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                  child: ListView(
                children: [
                  CheckboxListTile(
                    checkboxShape: CircleBorder(),
                    title: Text(widget. users[index].name),
                    value: true,
                    onChanged: (value) {},
                  ),
                  CheckboxListTile(
                    checkboxShape: CircleBorder(),
                    title: Text("Nabil"),
                    value: false,
                    onChanged: (value) {},
                  ),
                ],
              ))
            ],
          ),
        ));
  }
}
*/
import 'package:chat_app_with_firebase/models/Group-model.dart';
import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EditGroupScreen extends StatefulWidget {
  final ChatUsersGroup chatUsersGroup;
  const EditGroupScreen({super.key, required this.chatUsersGroup});

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  TextEditingController groupName = TextEditingController();
  //late TextEditingController _groupNameController;
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  List<String> _selectedMembers = [];
  //List<String> _userContacts = [];
  List<String> members = [];

  List<String> myContacts = [];
 

  @override
  void initState() {
    super.initState();
    
        
    groupName = TextEditingController(
        text: widget.chatUsersGroup.name ?? 'Unnamed Group');

    // Initialize with existing members (excluding current user)
    _selectedMembers = List<String>.from(widget.chatUsersGroup.members ?? []);
    _selectedMembers.removeWhere((id) => id == _currentUserId);
  }

  Future<void> _updateGroup() async {
    try {
      // Merge selected members with current user (admin)
      final updatedMembers = [..._selectedMembers, _currentUserId];

      await FirebaseFirestore.instance
          .collection('Group')
          .doc(widget.chatUsersGroup.id)
          .update({
        'name': groupName.text.trim(),
        'members': updatedMembers,
         'last_updated': FieldValue.serverTimestamp(), // Better timestamp handling
        //'last_updated': DateTime.now(),
      });

      //Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating group: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
      return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: 
            
               _updateGroup,
              
            
          
             //Navigator.pop(context);
          /////_updateGroup,
          label: const Text("Save Changes"),
          icon: const Icon(Iconsax.tick_circle),
        ),
        appBar: 
        AppBar(
          title: const Text("Edit Group"),
        ),

       
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Group Name Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[200],
                    child: Icon(Iconsax.people, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: groupName,
                      decoration: InputDecoration(
                        labelText: 'Group Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Member Selection Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Select Members',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),

                    // Selected Members Preview
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where(FieldPath.documentId,
                              whereIn: _selectedMembers)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final selectedUsers = snapshot.data!.docs
                              .map((doc) => UserModelContacts.fromDocument(doc))
                              .toList();

                          return SizedBox(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: selectedUsers.length,
                              itemBuilder: (context, index) {
                                final user = selectedUsers[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                      ),
                                      Text(user.name,
                                          style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const Divider(),
                    const SizedBox(height: 8),

                    // Contacts List
                    Expanded(
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(_currentUserId)
                            .snapshots(),
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          myContacts = List<String>.from(
                              (userSnapshot.data!.data()
                                      as Map<String, dynamic>)['my_users'] ??
                                  []);

                          if (myContacts.isEmpty) {
                            return const Center(
                                child: Text('No contacts found'));
                          }

                          return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .where(FieldPath.documentId,
                                    whereIn: myContacts)
                                .snapshots(),
                            builder: (context, contactsSnapshot) {
                              if (!contactsSnapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              final contacts = contactsSnapshot.data!.docs
                                  .map((doc) =>
                                      UserModelContacts.fromDocument(doc))
                                  .where((user) => user.id != _currentUserId)
                                  .toList();

                              return ListView.builder(
                                itemCount: contacts.length,
                                itemBuilder: (context, index) {
                                  final contact = contacts[index];
                                  final isSelected =
                                      _selectedMembers.contains(contact.id);

                                  return CheckboxListTile(
                                    value: isSelected,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          _selectedMembers.add(contact.id!);
                                        } else {
                                          _selectedMembers.remove(contact.id);
                                        }
                                      });
                                    },
                                    title: Text(contact.name),
                                    secondary: CircleAvatar(),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
/*
  @override
  void dispose() {
    groupName.dispose();
    super.dispose();
  }*/
}
