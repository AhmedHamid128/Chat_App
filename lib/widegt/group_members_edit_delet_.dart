import 'package:chat_app_with_firebase/Model/AlertDialog.dart';
import 'package:chat_app_with_firebase/models/Group-model.dart';
import 'package:chat_app_with_firebase/widegt/edit_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class group_member_edit_delet extends StatefulWidget {
  final ChatUsersGroup chatUsersGroup;
  final String currentUserId;
  group_member_edit_delet(
      {super.key, required this.chatUsersGroup, required this.currentUserId});

  @override
  State<group_member_edit_delet> createState() =>
      _group_member_edit_deletState();
}

class _group_member_edit_deletState extends State<group_member_edit_delet> {
  bool get iscurrentUserAdmin =>
      widget.chatUsersGroup.admin!.contains(widget.currentUserId) ?? false;

  // function to delete membere
  Future<void> deleteMember(String memberId) async {
    setState(() {
      widget.chatUsersGroup.members!.remove(memberId);
    });
    final groupUpdate = FirebaseFirestore.instance
        .collection('Group')
        .doc(widget.chatUsersGroup.id);

    await groupUpdate.update({
      // ممكن تحذف اي عضو حتي الادمن
      'members': FieldValue.arrayRemove([memberId]),
      'admins_id': FieldValue.arrayRemove([memberId]),
    });
  }

  // function to make any person admin
  Future<void> makeAdmin(String memberId) async {
    final groupUpdate = FirebaseFirestore.instance
        .collection('Group')
        .doc(widget.chatUsersGroup.id);

    await groupUpdate.update({
      'admins_id': FieldValue.arrayUnion([memberId]),
    });
    setState(() {
      widget.chatUsersGroup.admin!.add(memberId);
    });
  }

  @override
  // عرض قائمة الأعضاء المحدثة تلقائيًا
  // get data from firebase instanc
  late Stream<DocumentSnapshot> _groupStream;

  // عرض قائمة الأعضاء المحدثة تلقائيًا
  @override
  void initState() {
    super.initState();
    _groupStream = FirebaseFirestore.instance
        .collection('Group')
        .doc(widget.chatUsersGroup.id)
        .snapshots();
  }

  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
      return Scaffold(
        appBar: AppBar(title: Text(//' Member Group'
            widget.chatUsersGroup.name.toString()), actions: [
          IconButton(
            onPressed: () async {
              // Get the latest group data
              //DocumentSnapshot
              final groupSnapshot = await FirebaseFirestore.instance
                  .collection('Group')
                  .doc(widget.chatUsersGroup.id)
                  .get();

              String currentGroupName = groupSnapshot['name'];

              // Show confirmation dialog
              bool confirm = await ShowEditDialog(context, currentGroupName);

              // Navigate only if user confirmed
              if (confirm && mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditGroupScreen(
                            chatUsersGroup: widget.chatUsersGroup,
                          )),
                );
              }
            },
            icon: Icon(Iconsax.user),
          ),
        ]),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Group')
                        .doc(widget.chatUsersGroup.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return ListView.builder(
                          itemCount: widget.chatUsersGroup.members!.length,
                          itemBuilder: (context, index) {
                            final memberId =
                                widget.chatUsersGroup.members?[index];
                            final isAdmin = widget.chatUsersGroup.admin!
                                    .contains(memberId) ??
                                false;

                            return StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(memberId)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListTile(
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              bool confirm =
                                                  await showConfirmationDialog(
                                                      context,
                                                      snapshot.data!
                                                          .data()!['name']);
                                              if (confirm) {
                                                await deleteMember(memberId);
                                              }

                                              //deleteMember(memberId);
                                            },
                                            icon: Icon(Iconsax.trash),
                                            color: Colors.red,
                                          ),
                                          // if admin not apear
                                          if (!isAdmin)
                                            IconButton(
                                              onPressed: () async {
                                                bool confirm =
                                                    await showAdminAlert(
                                                        context,
                                                        snapshot.data!
                                                            .data()!['name']);
                                                if (confirm) {
                                                  await makeAdmin(memberId);
                                                }

                                                //makeAdmin(memberId);
                                              },
                                              icon: Icon(Iconsax.user_tick),
                                              color: Colors.green,
                                            ),
                                        ],
                                      ),
                                      title:
                                          Text(snapshot.data!.data()!['name']),
                                      subtitle: isAdmin ? Text('Admin') : null,
                                    );
                                  }
                                  return CircularProgressIndicator();
                                });
                          });
                    }),
              )
            ],
          ),
        ),
      );
    });
  }
}

