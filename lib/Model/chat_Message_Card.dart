import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_with_firebase/firebase/firebase_database.dart';
import 'package:chat_app_with_firebase/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class ChatMessageCard extends StatefulWidget {
  final Message messageitem;
  final String roomId;
  final bool Selected;
  const ChatMessageCard(
      {super.key, 
      required this.index,
      required this.messageitem,
      required this.roomId,
      required this.Selected});

  final int index;

  @override
  State<ChatMessageCard> createState() => _ChatMessageCardState();
}

class _ChatMessageCardState extends State<ChatMessageCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.messageitem.ToId == FirebaseAuth.instance.currentUser!.uid) {
      FireData().readMessage(widget.roomId, widget.messageitem.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? imageUrl;
    bool isMe =
        widget.messageitem.FromId == FirebaseAuth.instance.currentUser!.uid;
    bool isImage = widget.messageitem.type == 'image';

    // Assuming 'type' determines if it's an image
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: widget.Selected
              ? Colors.grey.withOpacity(0.5)
              : Colors.transparent),
      child: Row(
        mainAxisAlignment:
           
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          isMe
              ? IconButton(onPressed: () {}, icon: Icon(Iconsax.message_edit))
              :const SizedBox(),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isMe
                    ? 16
                    : 0), // لو انا اللي باعت يعني انا المستخدم خليها زي الردياس يعني زي الدايره
                topRight: Radius.circular(isMe ? 0 : 16),
                bottomLeft:const Radius.circular(16),
                bottomRight:const Radius.circular(16),
              ),
            ),
            color:
                isMe //لو انا اللي باعت خلي اللون اسود لو الشخص الثاني باعت خلي اللون اخضرر
                    ? Color.fromARGB(255, 30, 31, 30)
                    : Color.fromARGB(255, 40, 119, 66),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width / 2 - 20,
                // in this csuses use mediaQuery to  لضمان أن الرسالة لا تتجاوز هذا العرض
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    isImage
                        ? 
                        
                        Container(
                            child: CachedNetworkImage(
                               
                              imageUrl: widget.messageitem.msg!,
                              placeholder: (context, url) {
                                return const CircularProgressIndicator();
                                
                              },
                               width: 200, 
                            height: 200, 
                            fit: BoxFit.cover,
                             
                            ),
                        )
                               : Text(widget.messageitem.msg!),
                    Row(
                      children: [
                     const   Spacer(),
                      const  SizedBox(
                          width: 6,
                        ),
                        Text(
                          DateFormat('MMM d, h:mm a')
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(widget.messageitem.createdAt!)))
                              .toString(),
                          style:const TextStyle(fontSize: 11),
                        ),
                        isMe
                            ? Icon(
                                Iconsax.tick_circle,
                                color: widget.messageitem.read == ''
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
      ),
    );
  }
}
