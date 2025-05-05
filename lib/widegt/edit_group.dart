
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
   //late TextEditingController _groupNameController;
  TextEditingController groupName = TextEditingController();
 
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  List<String> _selectedMembers = [];
  
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
                                    const  CircleAvatar(
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
                                    secondary:const CircleAvatar(),
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

}
