import 'package:chat_app_with_firebase/models/Room_model.dart';
import 'package:chat_app_with_firebase/models/message_model.dart';
import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:chat_app_with_firebase/widegt/ChatScreen2.dart';
import 'package:chat_app_with_firebase/widegt/chat_screene.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class model_list_tile extends StatelessWidget {
  final ChatRoom item;
  const model_list_tile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    /*
  item.members!: قائمة أعضاء الغرفة.

where(...): يفلتر القائمة لاستبعاد ID المستخدم الحالي.

first: يأخذ أول عنصر في القائمة المفلترة (المستخدم الآخر
  */
    String userId = item.members!
        .where((element) => element != FirebaseAuth.instance.currentUser!.uid)
        .first;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ChatUser chatuser = ChatUser.fromJson(snapshot.data!
                .data()!); // convert data to  ChatUser by using function fromJson
            return Card(
              child: ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => 
                        ChatScreene(
                              roomId: item.id!,
                              chatuser: chatuser,
                            ),
                            
                            
                            )),
                leading: CircleAvatar(),
                title: Text(chatuser.name ??
                    'user unknown'), // يعرض اسم المستخدم، وإذا كان الاسم غير متوفر يُعرض "user unknown".
                subtitle: Text(
                  item.lastMessage!.isEmpty
                      ? chatuser.about! ?? ""
                      : item.lastMessage!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Room')
                        .doc(item.id)
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
                          if (item.lastMesssageTime != null &&
                              item.lastMesssageTime.toString().isNotEmpty) {
                            try {
                              formattedDate =
                                  DateFormat('MMM d, h:mm a').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(item.lastMesssageTime.toString()),
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
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}

/*
                      final unReadlist = snapshot.data?.docs
                          .map((e) => Message.fromJson(e.data()))
                          .where((Element) => Element.read != " ")
                          .where((Element) =>
                              Element.FromId ==
                              FirebaseAuth.instance.currentUser!.uid);
                      return unReadlist!.length == 0 
                          ? Badge(
                              backgroundColor: Colors.amber[200],
                              label: Text(unReadlist.length.toString()),
                            )
                          : Text(DateFormat('MMM d, h:mm a')
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(item.lastMesssageTime.toString())))
                              .toString());
                              */

/*
                          return hasUnreadMessages
                              ? Badge(
                                  backgroundColor: Colors.amber[200],
                                  label: Text(unReadList.length.toString()),
                                )
                              : Text(
                                  DateFormat('MMM d, h:mm a').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(
                                          item.lastMesssageTime.toString()),
                                    ),
                                  ),
                                );
                        } else {
                          return CircularProgressIndicator();
                        }
                      })),
                      */
