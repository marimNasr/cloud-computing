import 'dart:math';

class Message {
  final String message;
  final String sender;
  final String receiver;
  final DateTime createdAt;

  Message({
    required this.message,
    required this.sender,
    required this.receiver,
    required this.createdAt,
  });

  // Factory constructor to create a Message from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'] ?? '',
      sender: json['sender'] ?? '',
      receiver: json['receiver'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created at'] ?? 0),
    );
  }

  // To JSON function to send data to Firebase
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sender': sender,
      'receiver': receiver,
      'created at': createdAt.millisecondsSinceEpoch,
    };
  }
}
