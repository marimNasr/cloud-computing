import 'dart:developer';

import 'package:firebase_database/firebase_database.dart'; // Import Realtime Database
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../Authentication/presentation/views/signIn.dart';
import '../../../chat/presentation/views/chat_screen.dart';
import '../../data/channel_model.dart';

class ChannelsPage extends StatelessWidget {
  const ChannelsPage({super.key});
  static String routeName = "channelsPage";
  static final realtimeDatabaseRef = FirebaseDatabase.instance.ref().child('channels');


  @override
  Widget build(BuildContext context) {
    final channelCollection = FirebaseFirestore.instance.collection("Channels");
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    final uID = FirebaseAuth.instance.currentUser?.uid;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            children: [
              const Text(
                "Channels",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              IconButton(onPressed: (){
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, SignIn.routeName);
              }, icon: Icon(Icons.logout_rounded, size: 25,color: Colors.red,))
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: channelCollection.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (snapshot.hasData) {
              final channels = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>?;
                if (data != null) {
                  return ChannelModel.fromJson(data);
                }
                return null;
              }).whereType<ChannelModel>().toList();

              if (channels.isEmpty) {
                return const Center(
                  child: Text(
                    "No Channels Available",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: channels.length,
                itemBuilder: (context, index) {
                  final channel = channels[index];
                  final isSubscribed = channel.Subscribers.contains(currentUserEmail);
                  final isOwner = channel.owner == currentUserEmail;
                  final docId = snapshot.data!.docs[index].id;  // docId from each snapshot

                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        channel.name[0].toUpperCase(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    title: Text(
                      channel.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      "Subscribers: ${channel.Subscribers.length}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            isSubscribed ? Icons.remove : Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            try {
                              final channelDoc = FirebaseFirestore.instance
                                  .collection("Channels").doc(docId);

                              if (isSubscribed) {
                                // Unsubscribe: Remove user from the channel and remove the channel from user's "channels" array
                                await channelDoc.update({
                                  "Subscribers": FieldValue.arrayRemove([currentUserEmail]),
                                });

                                await FirebaseFirestore.instance.collection("User").doc(uID).update({
                                  "channels": FieldValue.arrayRemove([docId]),  // Remove the channel from the user's "channels" array
                                });
                              } else {
                                // Subscribe: Add user to the channel and add the channel to user's "channels" array
                                await channelDoc.update({
                                  "Subscribers": FieldValue.arrayUnion([currentUserEmail]),
                                });

                                await FirebaseFirestore.instance.collection("User").doc(uID).update({
                                  "channels": FieldValue.arrayUnion([docId]),  // Add the channel to the user's "channels" array
                                });
                              }

                            } catch (e) {
                              debugPrint('Error updating channel: $e');
                            }
                          },
                        ),
                        if (isOwner)
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              try {
                                await channelCollection.doc(docId).delete();
                                await realtimeDatabaseRef.child(docId).remove();
                              } catch (e) {
                                debugPrint('Error deleting channel: $e');
                              }
                            },
                          ),
                      ],
                    ),
                    onTap: () {
                      if(isSubscribed) {
                        Navigator.pushNamed(context, chatPage.routeName, arguments: {
                          'channelName': channel.name,
                          'channelId': docId
                        });
                      }
                    },
                  );
                },
              );
            }

            return const Center(
              child: Text(
                "No Channels Available",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            // Show the dialog to add a new channel
            _showAddChannelDialog(context, channelCollection);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // Function to show the dialog for adding a new channel
  void _showAddChannelDialog(BuildContext context, CollectionReference channelCollection) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            "Add Channel",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Enter channel name",
              hintStyle: TextStyle(color: Colors.grey),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () async {
                final channelName = nameController.text.trim();
                if (channelName.isNotEmpty) {
                  try {
                    // Create the channel in Firestore
                    final channelRef = await channelCollection.add({
                      'Name': channelName,
                      'Subscribers': [],
                      'owner': FirebaseAuth.instance.currentUser!.email,
                    });

                    // Create the same channel in Realtime Database
                    await realtimeDatabaseRef.child(channelRef.id).set({
                      'Name': channelName,
                      'owner': FirebaseAuth.instance.currentUser!.email,
                      'messages': {},
                    });

                    Navigator.of(context).pop();
                  } catch (e) {
                    debugPrint("Error adding channel: $e");
                  }
                } else {
                  debugPrint("Channel name cannot be empty");
                }
              },
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
