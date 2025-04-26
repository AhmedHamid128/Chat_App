import 'package:chat_app_with_firebase/Model/list_tile_for_group.dart';
import 'package:chat_app_with_firebase/firebase/firebase_database.dart';
import 'package:chat_app_with_firebase/models/Group-model.dart';
import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class group_home extends StatefulWidget {
  const group_home({super.key});

  @override
  State<group_home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<group_home> {
  TextEditingController groupName = TextEditingController();
  final String myId = FirebaseAuth.instance.currentUser!.uid;
  // default list
  List<String> members = [];
  List<String> myContacts = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('group'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(
              context: context,
              builder: (context) {
                // use StatefulBuilder to make chanages in   showBottomSheet لحظيا
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setModalState) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(' Enter Your  Name Group'),
                                Spacer(),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Iconsax.scan4)),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        groupName.text = "";
                                      });
                                    },
                                    icon: Icon(Icons.cancel))
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Stack(children: [
                                  CircleAvatar(
                                    radius: 40,
                                  ),
                                  Positioned(
                                    bottom: -5,
                                    right: -5,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.add_a_photo),
                                    ),
                                  ),
                                ]),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: groupName,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            members.isNotEmpty
                                ? Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(150, 50),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(13)),
                                        backgroundColor:
                                            Color.fromARGB(255, 40, 119, 66),
                                      ),
                                      onPressed: () async {
                                        if (groupName.text != "") {
                                          await FireData().creatGroup(
                                              groupName.text, members);

                                          groupName.text = "";
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Text(
                                        'Create',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(),
                            Row(
                              children: [
                                Text("Members"),
                                Spacer(),
                              
                                Text("${members.length}",style: TextStyle(fontSize: 20),),
                    
                              ],
                            ),
                            SizedBox(
                              height: 10,
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
                                        snapshot.data!.data()!['my_users'] ??
                                            []);

                                    if (myContacts.isEmpty) {
                                      return Center(
                                          child: Text('No contacts found.'));
                                    }

                                    return StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .where(FieldPath.documentId,
                                              whereIn: myContacts)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final users = snapshot.data!.docs
                                              .map((doc) => UserModelContacts
                                                  .fromDocument(doc))
                                              // means Remove myname from members
                                              .where((Element) =>
                                                  Element.id != myId)
                                              .toList();

                                          return ListView.builder(
                                            itemCount: users.length,
                                            itemBuilder: (context, index) {
                                              final isSelected = members
                                                  .contains(users[index].id);
                                              return CheckboxListTile(
                                                checkboxShape: CircleBorder(),
                                                value: isSelected,
                                                onChanged: (bool? value) {
                                                  setModalState(() {
                                                    if (value == true) {
                                                      members.add(
                                                          users[index].id!);
                                                    } else {
                                                      members.remove(
                                                          users[index].id!);
                                                    }
                                                  });
                                                },
                                                title: Text(users[index].name),
                                              );
                                            },
                                          );
                                        } else {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      },
                                    );
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ),
                            ),

                            /*
                          CheckboxListTile(
                            checkboxShape: CircleBorder(),
                            value: true,
                            onChanged: (value) {},
                            title: Text('Ahmed'),
                          ),
                          CheckboxListTile(
                            checkboxShape: CircleBorder(),
                            value: false,
                            onChanged: (value) {},
                            title: Text('Ahmed'),
                          ),
                          */
                          ]),
                    ),
                  );
                });
              });
        },
        child: Icon(
          Iconsax.message_add_1,
          color: Colors.green,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Group')
                  .where('members',
                      arrayContains: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ChatUsersGroup> itemsGroup = snapshot.data!.docs
                      .map((e) => ChatUsersGroup.fromJson(e.data()))
                      .toList()
                    ..sort((a, b) =>
                        b.lastMessageTime!.compareTo(a.lastMessageTime!));
                  return ListView.builder(
                      itemCount: itemsGroup.length,
                      itemBuilder: (context, index) {
                        return model_list_tilefor_group(
                          chatUsersGroup: itemsGroup[index],
                        );
                      });
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
