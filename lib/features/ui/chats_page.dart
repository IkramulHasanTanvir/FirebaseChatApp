import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key, required this.chatPartnerId, required this.chatPartnerName});

  final String chatPartnerId;
  final String chatPartnerName;

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final _messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? _editingMessageId;
  bool _isEditing = false;

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final user = _auth.currentUser;
    if (user == null) return;

    if (_isEditing) {
      await _firestore.collection('messages').doc(_editingMessageId).update({
        'text': _messageController.text.trim(),
        'edited': true,
      });

      setState(() {
        _isEditing = false;
        _editingMessageId = null;
      });
    } else {
      final messageDocRef = _firestore.collection('messages').doc();
      await messageDocRef.set({
        'text': _messageController.text.trim(),
        'sender': user.email,
        'receiver': widget.chatPartnerId,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'sending',
        'participants': [user.email, widget.chatPartnerId],
        'userId': user.uid, // Store the user's UID here
      });

      await messageDocRef.update({'status': 'sent'});
    }

    _messageController.clear();
  }

  void _editMessage(String messageId, String text) {
    setState(() {
      _messageController.text = text;
      _isEditing = true;
      _editingMessageId = messageId;
    });
  }

  void _deleteMessage(String messageId) async {
    await _firestore.collection('messages').doc(messageId).delete();
  }

  String _formatTimestamp(Timestamp? timestamp) {
    return timestamp == null ? "" : DateFormat('hh:mm a').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = _auth.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
          title: Text(widget.chatPartnerName), backgroundColor: Colors.amber),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .where('participants', arrayContains: userEmail)
                  .where('userId', isEqualTo: _auth.currentUser?.uid)  // Filter by userId
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final messages = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return (data['sender'] == userEmail && data['receiver'] == widget.chatPartnerId) ||
                      (data['sender'] == widget.chatPartnerId && data['receiver'] == userEmail);
                }).toList();

                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      "No messages yet. Start the conversation!",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index].data() as Map<String, dynamic>;
                    final messageId = messages[index].id;
                    final isMe = message['sender'] == userEmail;
                    final timestamp = message['timestamp'] as Timestamp?;
                    final isEdited = message['edited'] ?? false;

                    if (!isMe) {
                      _firestore.collection('messages').doc(messageId).update({'status': 'seen'});
                    }

                    return Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          child: Row(
                            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              Text(isMe ? "You" : widget.chatPartnerName,
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                              if (isMe) _buildDropdownMenu(messageId, message['text']),
                            ],
                          ),
                        ),
                        BubbleNormal(
                          text: message['text'],
                          isSender: isMe,
                          color: isMe ? Colors.amber.shade100 : Colors.grey[300]!,
                          tail: true,
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 5),
                          child: Row(
                            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              Text(_formatTimestamp(timestamp),
                                  style: const TextStyle(fontSize: 10, color: Colors.black54)),
                              if (isEdited)
                                const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text('Edited', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                ),
                            ],
                          ),
                        ),
                      ],
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: _isEditing ? "Edit message" : "Type a message",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.amber),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownMenu(String messageId, String messageText) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'Edit') _editMessage(messageId, messageText);
        if (value == 'Delete') _deleteMessage(messageId);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'Edit', child: Text('Edit')),
        const PopupMenuItem(value: 'Delete', child: Text('Delete')),
      ],
      child: const Padding(
        padding: EdgeInsets.only(left: 6),
        child: Icon(Icons.more_vert, size: 18, color: Colors.black54),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
