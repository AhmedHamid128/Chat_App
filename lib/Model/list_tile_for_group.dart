import 'package:chat_app_with_firebase/models/Group-model.dart';
import 'package:chat_app_with_firebase/models/message_model.dart';
import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:chat_app_with_firebase/widegt/group_chat_screene.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class model_list_tilefor_group extends StatefulWidget {
  final ChatUsersGroup chatUsersGroup;
  const model_list_tilefor_group({super.key, required this.chatUsersGroup});

  @override
  State<model_list_tilefor_group> createState() => _model_list_tileState();
}

class _model_list_tileState extends State<model_list_tilefor_group> {

  void markMessagesAsRead() async {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final messageDocs = await FirebaseFirestore.instance
      .collection('Group')
      .doc(widget.chatUsersGroup.id)
      .collection('Messages')
      .get();

  for (var doc in messageDocs.docs) {
    final data = doc.data();
    if (data['read'] == '' && data['FromId'] != currentUserId) {
      await doc.reference.update({'read': currentUserId}); // or true / timestamp
    }
  }
  
}




  @override
void initState() {
  super.initState();
  markMessagesAsRead();
}

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GroupChatScreene(
                  chatUserGroup: widget.chatUsersGroup,
                  // قيم افتراضيه
                  roomId: '',
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
                      //lastActivated: ''
                      )))),
      leading: CircleAvatar(
        //  this future like talagrame  == aperar frist and second letters frome Name of Group
        child: Text(
          widget.chatUsersGroup.name != null &&
                  widget.chatUsersGroup.name!.isNotEmpty
              ? widget.chatUsersGroup.name!.length >= 2
                  ? widget.chatUsersGroup.name!.substring(0, 2).toUpperCase()
                  : widget.chatUsersGroup.name!.toUpperCase()
              : '??',
        ),
      ),
      title: Text(widget.chatUsersGroup.name.toString()),
      subtitle: Text(
        widget.chatUsersGroup.lastMessage == ""
            ? widget.chatUsersGroup.about.toString()
            : widget.chatUsersGroup.lastMessage.toString(),
        maxLines: 1,
      ),
      //trailing: Text(widget.chatUsersGroup.lastMessageTime.toString()),

      trailing: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Group')
                        .doc(widget.chatUsersGroup.id)
                        .collection('Messages')
                        .snapshots(),
                    builder: (context, messageSnapshot) {
                      if (messageSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SizedBox(); // Or some placeholder
                      }
                      if (messageSnapshot.hasData) {
                        final unReadList = messageSnapshot.data?.docs
                            .map((e) => Message.fromJson(e
                                .data())) // عند توفر البيانات في messageSnapshot، يتم تحويل المستندات (docs) إلى قائمة من كائنات Message
                            .where((element) =>
                                element.read ==
                                    '' && // لم يتم قراءتها (element.read == '')،
                                element.FromId != //وترسل من طرف المستخدم الآخر
                                    FirebaseAuth.instance.currentUser!.uid)
                            .toList();

                        //يتم التحقق مما إذا كانت هناك رسائل غير مقروءة
                        bool hasUnreadMessages =
                            unReadList != null && unReadList.isNotEmpty;

                        if (hasUnreadMessages) {
                          return Badge(
                            backgroundColor: Colors.amber[200],
                            label: Text(unReadList.length.toString()),
                          );
                        } else {
                          // Safe parsing of `lastMesssageTime`
                          String formattedDate = '';
                          if (widget.chatUsersGroup.lastMessageTime != null &&
                              widget.chatUsersGroup.lastMessageTime.toString().isNotEmpty) {
                            try {
                              formattedDate =
                                  DateFormat('MMM d, h:mm a').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(widget.chatUsersGroup.lastMessageTime.toString()),
                                ),
                              );
                            } catch (e) {
                              // Handle parsing error, log, or set a default value
                              formattedDate = 'Invalid date';
                            }
                          } else {
                            formattedDate = '';
                          }

                          return Text(formattedDate);
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),


    );
  }
}
