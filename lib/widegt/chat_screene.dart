


import 'package:chat_app_with_firebase/Model/chat_Message_Card.dart';
import 'package:chat_app_with_firebase/firebase/firebase_database.dart';
import 'package:chat_app_with_firebase/models/message_model.dart';
import 'package:chat_app_with_firebase/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';



class ChatScreene extends StatefulWidget {
   const ChatScreene({super.key, required this.roomId, required this.chatuser});
  final String roomId;
  final ChatUser chatuser;

  @override
  State<ChatScreene> createState() => _ChatScreeneState();
}

class _ChatScreeneState extends State<ChatScreene> {
  TextEditingController messagecon = TextEditingController();
 
  List selectedMsg = [];
  List copyMesg = [];
  final ImagePicker _picker = ImagePicker();
   ChatUser? me;
  Uint8List? selectedImage; 

  
    Future<String> uploadImage(Uint8List imageBytes) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('profilePictures/${me!.id}.jpg');
    await imageRef.putData(imageBytes);
    final url = await imageRef.getDownloadURL();
    return url;



  }

 Future<void> sendImageMessage(String imageUrl) async {
    await FireData().sendMessage(
      widget.chatuser.id!,
      imageUrl,
      widget.roomId,
      type: 'image', 
    );
  }
 

  

  @override
  
  Widget build(BuildContext context) {

    return Scaffold(
     
      appBar: AppBar(
        backgroundColor: Color(0xff0a0b0f).withOpacity(0.5),
        title: Padding(
          padding:const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              
              Text(widget. chatuser.name!),
          
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').doc(widget.chatuser.id).snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return Text(
                    
                    snapshot.data!.data()! ['online'] ==  'true' 
                    ?"online" :
                    widget.chatuser.lastActivted!,
                    style:const TextStyle(fontSize: 12),
                  );
                  

                  }
                  else{
                    return Container();

                  }
                  
                }
              ),
            ]
          ),
          

        ),
        
        
        actions: [  
          copyMesg.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: copyMesg.join(' \n'),
                      ),
                    ); // \n to make spacae when copy between messages

                    setState(() {
                      selectedMsg.clear();
                      copyMesg.clear();
                    });
                  },
                  icon: Icon(Icons.copy))
              : Container(),
          selectedMsg.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    FireData().DeletMsaage(widget.roomId, selectedMsg);

                    setState(() {
                     
                      copyMesg.clear();
                    });
                  },
                  icon: Icon(Icons.delete),
                )
              : Container()
        ],
      ),
      body: Stack(
        children: [
          // Background Image with Opacity
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
               
                
                
                image:const NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR62kVVpw-0aYVNLasj24fBnpXWsrdMXPt4nA&s'),
                    
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), // Adjust opacity here
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Chat Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Room')
                          .doc(widget.roomId)
                          .collection('Messages')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Message> Messageitems = snapshot.data!.docs
                              .map((e) => Message.fromJson(e.data()))
                              .toList()
                            ..sort(
                                (a, b) => b.createdAt!.compareTo(a.createdAt!));

                          return Messageitems.isNotEmpty
                              ? ListView.builder(
                                  reverse: true,
                                  itemCount: Messageitems.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        selectedMsg.length > 0
                                            ? selectedMsg.contains(
                                                    Messageitems[index].id)
                                                ? selectedMsg.remove(
                                                    Messageitems[index].id)
                                                : selectedMsg
                                                    .add(Messageitems[index].id)
                                            : null;
                                        copyMesg.isNotEmpty
                                            ? Messageitems[index].type == 'text'
                                                ? copyMesg.contains(
                                                        Messageitems[index].msg)
                                                    ? copyMesg.remove(
                                                        Messageitems[index].msg)
                                                    : copyMesg.add(
                                                        Messageitems[index].msg)
                                                : null
                                            : null;
                                      },
                                      onLongPress: () {
                                        setState(() {
                                          selectedMsg.contains(
                                                  Messageitems[index].id)
                                              ? selectedMsg.remove(
                                                  Messageitems[index].id)
                                              : selectedMsg
                                                  .add(Messageitems[index].id);
                                          // print(selectedMsg);
                                          Messageitems[index].type == 'text'
                                              ? copyMesg.contains(
                                                      Messageitems[index].msg)
                                                  ? copyMesg.remove(
                                                      Messageitems[index].msg)
                                                  : copyMesg.add(
                                                      Messageitems[index].msg)
                                              : null;
                                          // print(copyMesg);
                                        });
                                      },
                                      child: ChatMessageCard(
                                        Selected: selectedMsg
                                            .contains(Messageitems[index].id),
                                        messageitem: Messageitems[index],
                                        roomId: widget.roomId,
                                        index: index,
                                      ),
                                    );
                                  })
                              : Center(
                                  child: GestureDetector(
                                    onTap: () => FireData().sendMessage(
                                        widget.chatuser.id!,
                                        "اَلَسَلَاَمَ عَلَيَكَمَ وًّرَحَمَةٍ اَلَلَهَ وًّبَرَكَاَتَهَ",
                                        widget.roomId),
                                    child: Card(
                                    
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                          return const CircularProgressIndicator();
                        }
                      }),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                       
                        child: TextField(
                          controller: messagecon,
                          maxLines: 5,
                          minLines: 1,
                          decoration: InputDecoration(
                            suffixIcon: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: ()async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    final bytes = await pickedFile.readAsBytes();
    String imageUrl = await uploadImage(bytes);
    await sendImageMessage(imageUrl);
  }
},
                                  
                                  icon:const Icon(Iconsax.gallery),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon:const Icon(Iconsax.camera),
                                ),
                              ],
                            ),
                            contentPadding:const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            hintText: 'message',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                    IconButton.filled(
                        onPressed: () {
                          if (messagecon.text != '') {
                            FireData()
                                .sendMessage(widget.chatuser.id!,
                                    messagecon.text, widget.roomId)
                                .then((value) {
                              setState(() {
                                messagecon.text = '';
                              });
                            });
                          }
                        },
                        icon:const Icon(Icons.send))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

