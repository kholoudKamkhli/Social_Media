import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';


class ChatScreen extends StatefulWidget {
  final String userId1;
  final String userId2;

  const ChatScreen({
    Key? key,
    required this.userId1,
    required this.userId2,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    setState(() {
      _isLoading = true;
    });
    try {
      QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
          .collection(Message.COLLECTION_NAME)
          .where('senderId', isEqualTo: widget.userId1)
          .where('recieverId', isEqualTo: widget.userId2)
          .orderBy('dateTime')
          .get();

      QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
          .collection(Message.COLLECTION_NAME)
          .where('senderId', isEqualTo: widget.userId2)
          .where('recieverId', isEqualTo: widget.userId1)
          .orderBy('dateTime')
          .get();

      List<Message> messages = [];
      for (var doc in querySnapshot1.docs) {
        messages.add(Message.fromJson(doc.data() as Map<String, dynamic>));
      }
      for (var doc in querySnapshot2.docs) {
        messages.add(Message.fromJson(doc.data() as Map<String, dynamic>));
      }
      messages.sort((a, b) => a.dateTime.compareTo(b.dateTime));

      setState(() {
        _messages = messages;
        _isLoading = false;
      });

      // Scroll to the bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    } catch (e) {
      print("Error getting messages: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    Message newMessage = Message(
      content: _messageController.text.trim(),
      dateTime: DateTime.now().millisecondsSinceEpoch,
      senderId: widget.userId1,
      recieverId: widget.userId2,
    );

    try {
      await FirebaseFirestore.instance
          .collection(Message.COLLECTION_NAME)
          .add(newMessage.toJson());
      _messageController.clear();
      _fetchMessages();
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.userId2}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                Message message = _messages[index];
                bool isSender = message.senderId == widget.userId1;
                return Align(
                  alignment:
                  isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSender ? Colors.amber : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: isSender
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.content,
                          style: TextStyle(
                            color: isSender ? Colors.black : Colors.black,
                          ),
                        ),
                        Text(
                          DateTime.fromMillisecondsSinceEpoch(message.dateTime)
                              .toLocal()
                              .toString(),
                          style: TextStyle(
                            color: isSender ? Colors.black54 : Colors.black54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}