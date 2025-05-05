import 'package:chat_app_with_firebase/Model/list_Tile_model_.dart';
import 'package:chat_app_with_firebase/firebase/firebase_database.dart';
import 'package:chat_app_with_firebase/models/Room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Chat_Home extends StatefulWidget {
  const Chat_Home({super.key});

  @override
  State<Chat_Home> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<Chat_Home> {
  TextEditingController emailController = TextEditingController();
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding:const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Enter your friend's email",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      const  Spacer(),
                        IconButton.filled(
                          onPressed: () {},
                          icon:const Icon(Iconsax.scan_barcode),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon:const Icon(Icons.cancel))
                      ],
                    ),
                  const  SizedBox(
                      height: 30,
                    ),
                    Row(children: [
                      Expanded(
                          child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            prefixIcon:const Icon(Icons.mark_email_unread_rounded),
                            hintText: 'email your  Friend',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8))),
                      )),
                    ]),
                  const  SizedBox(
                      height: 60,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding:const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer),
                        onPressed: () async {
                          if (emailController.text != '') {
                            await FireData()
                                .createRoom(emailController.text, context);
                            setState(() {
                              emailController.text = '';
                            });
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child:const Center(
                          child: Text("Create Chat"),
                        ))
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Iconsax.message_add),
      ),
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Room')
                    .where(
                        'members', // يفلتر الغرف التي تحتوي على  members = ID المستخدم الحال
                        arrayContains: FirebaseAuth.instance.currentUser!.uid)
                    //.orderBy('last_message_time', descending: true) // يمكن تفعيل الترتيب حسب آخر رسالة
                    .snapshots(), // يعطي تحديثات فورية عند أي تغيير.
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //يرتب الغرف تنازلياً بناء على وقت آخر رسالة
                    List<ChatRoom> items = snapshot.data!.docs
                        .map((e) => ChatRoom.fromJson(e.data()))
                        .toList()
                      ..sort(
                        (a, b) =>
                            b.lastMesssageTime!.compareTo(a.lastMesssageTime!),
                      );

                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return model_list_tile(item: items[index]);
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


