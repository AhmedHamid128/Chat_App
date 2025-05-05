import 'package:chat_app_with_firebase/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ChatGroupmesagesCard extends StatefulWidget {
  final Message message;
  final int index;
  const ChatGroupmesagesCard({super.key, required this.index, required this.message});

  @override
  State<ChatGroupmesagesCard> createState() => _ChatGroupmesagesCardState();
}

class _ChatGroupmesagesCardState extends State<ChatGroupmesagesCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = widget.message.FromId == FirebaseAuth.instance.currentUser!.uid;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isMe
            ? IconButton(onPressed: () {}, icon:const Icon(Iconsax.message_edit))
            :const SizedBox(),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 16 : 0),
              topRight: Radius.circular(isMe ? 0 : 16),
              bottomLeft:const Radius.circular(16),
              bottomRight:const Radius.circular(16),
            ),
          ),
          color: isMe
              ? Color.fromARGB(255, 30, 31, 30)
              : Color.fromARGB(255, 40, 119, 66),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width / 2 - 20,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  !isMe
                      ? StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.message.FromId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? Text(
                                    snapshot.data!.data()!['name'],
                                    style:const TextStyle(
                                      color: Colors.white, // Light mint green

                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  )
                                : Container();
                          })
                      :const SizedBox(),
                  Text(widget.message.msg!),
                  Row(
                    children: [
                    const  Spacer(),
                      Text(
                        widget.message.createdAt!,
                        style:const TextStyle(fontSize: 11),
                      ),
                    const  SizedBox(
                        width: 6,
                      ),
                      isMe
                          ? Icon(
                              Iconsax.tick_circle,
                              color: widget.message.read == ""
                                  ? Colors.grey
                                  : Colors.blueAccent,
                              size: 18,
                            )
                          :const SizedBox(
                              width: 1,
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
