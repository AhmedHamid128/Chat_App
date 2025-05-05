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
   
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      members: json['members'] ?? [],
      lastMessage: json['last_message'] ?? '',
      lastMesssageTime: json['last_time_message'] ?? '',

      createdAt: json['created_at'],
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
