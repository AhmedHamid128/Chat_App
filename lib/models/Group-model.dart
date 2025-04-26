class ChatUsersGroup {
  String? id;
  String? name;
  List? admin;

  List? members;
  String? about;
  String? image;

  String? createdAt;
  String? lastMessage;
  String? lastMessageTime;

  //List<String>? myUsers;

  ChatUsersGroup({
    required this.id,
    required this.name,
    required this.admin,
    required this.members,
    required this.about,
    required this.image,
    required this.createdAt,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory ChatUsersGroup.fromJson(Map<String, dynamic> json) {
    return ChatUsersGroup(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      admin: json['admins_id'] ?? [],
      members: json['members'] ?? [],
      about: json['about'] ?? "",
      image: json['image'] ?? "",
      createdAt: json['created_at'] ?? "",
      lastMessage: json['last_message'] ?? "",
      lastMessageTime: json['last_message_time'] ?? "",
    );
  }
  // to receve it in firbase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'admins_id': admin,
      'members': members,
      'about': about,
      'image': image,
      'created_at': createdAt,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
    };
  }
}
