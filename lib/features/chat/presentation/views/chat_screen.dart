
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../data/message.dart';
import '../widgets/chat_recieve.dart';
import '../widgets/chat_sent.dart';

class chatPage extends StatefulWidget {
  const chatPage({super.key});
  static String routeName = "Chat";

  @override
  State<chatPage> createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  TextEditingController messageController = TextEditingController();
  ScrollController _scrollController = ScrollController(); // Scroll controller
  late String channelId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
    final channelName = args?['channelName'] ?? "";
    channelId = args?['channelId'] ?? "";
    final DatabaseReference _messageRef = FirebaseDatabase.instance.ref().child("channels/$channelId/messages");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(channelName, style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: _messageRef.onValue,
                builder: (context, snapshot) {
                  if (isLoading && snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                    return const Center(
                      child: Text('No messages available.', style: TextStyle(color: Colors.white)),
                    );
                  }

                  final data = snapshot.data!.snapshot.value as Map<Object?, Object?>;
                  List<Message> newMessages = [];

                  // Convert data to Message objects and add them to newMessages
                  data.forEach((key, value) {
                    if (value is Map<Object?, Object?>) {
                      final message = Message.fromJson(Map<String, dynamic>.from(value));
                      newMessages.add(message);
                    }
                  });
                  //sort
                  newMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                  // to stop circular loading
                  if (isLoading) {
                      isLoading = false;
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.only(top: 10),
                    itemCount: newMessages.length,
                    itemBuilder: (context, index) {
                      return newMessages[index].sender == FirebaseAuth.instance.currentUser!.email
                          ? ChatSentWidget(message: newMessages[index])
                          : ChatRecieveWidget(message: newMessages[index]);
                    },
                  );
                },
              ),
            ),
            // Text field for sending messages
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: messageController,
                decoration: InputDecoration(
                  hintText: "Write Something",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {
                        _sendMessage(messageController.text);
                        messageController.clear();
                        _scrollToBottom();
                      }
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to send a message to the Realtime Database
  void _sendMessage(String messageText) {
    final sender = FirebaseAuth.instance.currentUser!.email!;
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final message = Message(
      message: messageText,
      sender: sender,
      receiver: 'someReceiver@example.com', // Set the receiver if needed
      createdAt: DateTime.fromMillisecondsSinceEpoch(timestamp),
    );

    final DatabaseReference _messageRef = FirebaseDatabase.instance.ref().child("channels/$channelId/messages");

    _messageRef.push().set(message.toJson()).then((_) {
      log("Message sent: ${message.message}");

      setState(() {});
    }).catchError((error) {
      log("Error sending message: $error");
    });
  }

  // Function to scroll to the bottom of the list
  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }
}
