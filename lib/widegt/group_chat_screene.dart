import 'package:chat_app_with_firebase/Model/Chat_GroupMesages_Card.dart';
import 'package:chat_app_with_firebase/firebase/firebase_database.dart';
import 'package:chat_app_with_firebase/models/Group-model.dart';
import 'package:chat_app_with_firebase/models/message_model.dart';
import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:chat_app_with_firebase/widegt/group_members_edit_delet_.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class GroupChatScreene extends StatefulWidget {
  final ChatUsersGroup chatUserGroup;
  final String roomId;
  final ChatUser chatuser;
  const GroupChatScreene(
      {super.key,
      required this.chatUserGroup,
      required this.roomId,
      required this.chatuser});

  @override
  State<GroupChatScreene> createState() => _ChatScreeneState();
}

class _ChatScreeneState extends State<GroupChatScreene> {
  TextEditingController messageGroupController = TextEditingController();
  // get data from firebase instanc
  late Stream<DocumentSnapshot> _groupStream;

  // عرض قائمة الأعضاء المحدثة تلقائيًا
  @override
  void initState() {
    super.initState();
    _groupStream = FirebaseFirestore.instance
        .collection('Group')
        .doc(widget.chatUserGroup.id)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
      return Scaffold(
        appBar: /*
        AppBar(
          title: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Column(
              children: [
                Text(widget.chatUserGroup.name.toString()),
                // to apear name of group in apove
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('id', whereIn: widget.chatUserGroup.members)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> membersName = [];
                      for (var element in snapshot.data!.docs) {
                        membersName.add(element.data()['name']);
                      }
                      return Text(
                        membersName.join(', '),
                        style: TextStyle(fontSize: 12),
                      );
                    }
                    return Container();
                  },
                )
              ],
            ),
          ),*/
            AppBar(
          title: StreamBuilder<DocumentSnapshot>(
            stream: _groupStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Text('Loading...');
              }

              final groupData = snapshot.data!.data() as Map<String, dynamic>;
              final groupName = groupData['name'] ?? 'Group';
              final members = List<String>.from(groupData['members'] ?? []);

              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    Text(groupName),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('id', whereIn: members)
                          .snapshots(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.hasData) {
                          List<String> membersName = [];
                          for (var element in userSnapshot.data!.docs) {
                            membersName.add(element.data()['name']);
                          }
                          return Text(
                            membersName.join(', '),
                            style: const TextStyle(fontSize: 12),
                          );
                        }
                        return Container();
                        //const SizedBox.shrink();
                      },
                    )
                  ],
                ),
              );
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => group_member_edit_delet(
                        // devalut
                        currentUserId: widget.chatuser.id.toString(),
                        chatUsersGroup: widget.chatUserGroup,
                        //memberIds: widget.chatUserGroup.members!.cast<String>(),
                        //groupId: widget.chatUserGroup.id!,
                      ),
                    ),
                  );
                },
                icon: Icon(Iconsax.user)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Group')
                        .doc(widget.chatUserGroup.id)
                        .collection('Messages')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Message> itemMessage = snapshot.data!.docs
                            .map((e) => Message.fromJson(e.data()))
                            .toList()
                          ..sort(
                            (a, b) => b.createdAt!.compareTo(a.createdAt!),
                          );
                        if (itemMessage.isEmpty) {
                          return Center(
                            child: GestureDetector(
                              onTap: () => FireData().sendGroupMessage(
                                  ' 👋اَلَسَلَاَمَ عَلَيَكَمَ وًّرَحَمَةٍ اَلَلَهَ وًّبَرَكَاَتَهu',
                                  widget.chatUserGroup.id!),
                              child: Card(
                                //color: Colors.white.withOpacity(0.8),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "👋",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        "اَلَسَلَاَمَ عَلَيَكَمَ وًّرَحَمَةٍ اَلَلَهَ وًّبَرَكَاَتَهَ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                              reverse: true,
                              itemCount: itemMessage.length,
                              itemBuilder: (context, index) {
                                return ChatGroupmesagesCard(
                                  message: itemMessage[index],
                                  index: index,
                                );
                              });
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: TextFormField(
                        maxLines: 5,
                        controller: messageGroupController,
                        minLines: 1,
                        decoration: InputDecoration(
                          suffixIcon: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Iconsax.gallery),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Iconsax.camera),
                              ),
                            ],
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          hintText: 'message',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  IconButton.filled(
                      onPressed: () async {
                        if (messageGroupController != Null) {
                          await FireData().sendGroupMessage(
                              messageGroupController.text,
                              widget.chatUserGroup.id!);
                          messageGroupController.text = "";
                        }
                      },
                      icon: Icon(Icons.send))
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
