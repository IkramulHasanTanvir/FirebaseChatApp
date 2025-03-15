import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatsPage extends StatefulWidget {
  final String chatPartnerId;
  final String chatPartnerName;

  const ChatsPage({super.key, required this.chatPartnerId, required this.chatPartnerName});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final _messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? _editingMessageId;
  bool _isEditing = false;

  String get _chatId {
    final userId = _auth.currentUser!.uid;
    return userId.hashCode <= widget.chatPartnerId.hashCode
        ? '$userId-${widget.chatPartnerId}'
        : '${widget.chatPartnerId}-$userId';
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    final user = _auth.currentUser;
    if (user == null) return;

    final text = _messageController.text.trim();
    _messageController.clear();

    if (_isEditing) {
      await _firestore.collection('messages').doc(_editingMessageId).update({'text': text, 'edited': true});
      setState(() => _isEditing = false);
    } else {
      await _firestore.collection('messages').add({
        'chatId': _chatId,
        'text': text,
        'senderId': user.uid,
        'receiverId': widget.chatPartnerId,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'sent',
      });
    }
  }

  void _editMessage(String messageId, String text) {
    setState(() {
      _messageController.text = text;
      _isEditing = true;
      _editingMessageId = messageId;
    });
  }

  String _formatTimestamp(Timestamp? timestamp) {
    return timestamp == null ? "" : DateFormat('hh:mm a').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    final userId = _auth.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(title: Text(widget.chatPartnerName), backgroundColor: Colors.amber),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .where('chatId', isEqualTo: _chatId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index].data() as Map<String, dynamic>;
                    final messageId = messages[index].id;
                    final isMe = message['senderId'] == userId;
                    final timestamp = message['timestamp'] as Timestamp?;
                    final isEdited = message['edited'] ?? false;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      child: Column(
                        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          BubbleNormal(
                            text: message['text'],
                            isSender: isMe,
                            color: isMe ? Colors.amber.shade100 : Colors.grey[300]!,
                            tail: true,
                          ),
                          Row(
                            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              Text(_formatTimestamp(timestamp), style: const TextStyle(fontSize: 10, color: Colors.black54)),
                              if (isEdited) const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Text('Edited', style: TextStyle(fontSize: 10)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: _isEditing ? "Edit message" : "Type a message",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.send, color: Colors.amber), onPressed: _sendMessage),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
