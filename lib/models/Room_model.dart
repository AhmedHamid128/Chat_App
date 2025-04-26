import 'dart:core';

class ChatRoom {
  String? id;
  List? members;
  String? lastMessage;
  String? lastMesssageTime;

  String? createdAt;

  ChatRoom({
    required this.id,
    required this.members,
    required this.lastMessage,
    required this.lastMesssageTime,
    required this.createdAt,
    //required DateTime lastMessageTime1,
    //required String lastMessageTime
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      members: json['members'] ?? [],
      lastMessage: json['last_message'] ?? '',
      lastMesssageTime: json['last_time_message'] ?? '',

      createdAt: json['created_at'],
      //lastMessageTime: '',
      //lastMessageTime1: (json['last_Message_Time'] as Timestamp).toDate(),
      //lastMesssageTime: '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'members': members,
      'last_message': lastMessage,
      'last_message_time': lastMesssageTime,
      'created_at': createdAt,
    };
  }
}
