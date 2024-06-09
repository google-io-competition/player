import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../multiplayer/firestore_controller.dart';

class ChatScreen extends StatelessWidget {
  final String lobbyId;
  final String userId;
  final FirestoreController firestoreController;

  const ChatScreen({super.key,
    required this.lobbyId,
    required this.userId,
    required this.firestoreController,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreController.getMessages(lobbyId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(messageData['text']),
                      subtitle: Text('User: ${messageData['userId']}'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(labelText: 'Enter message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (controller.text.isNotEmpty) {
                      await firestoreController.sendMessage(
                        lobbyId,
                        controller.text,
                        userId,
                      );
                      controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
