import 'dart:core';

class Message {
  String? id;
  String? ToId;

  String? FromId;
  String? msg;
  String? type;

  String? read;

  String? createdAt;

  Message({
    required this.id,
    required this.ToId,
    required this.FromId,
    required this.msg,
    required this.type,
    required this.read,
    required this.createdAt,
  });
  // to convert data from consructor use methodes of factory
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      msg: json['msg'],
      FromId: json['from_id'],
      ToId: json['to_id'], //المستلم
      createdAt: json['created_at'],
      read: json['read'],
      type: json['type'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'to_id': ToId,
      'from_id': FromId,
      'msg': msg,
      'type': type,
      'read': read,
      'created_at': createdAt,
    };
  }
}
