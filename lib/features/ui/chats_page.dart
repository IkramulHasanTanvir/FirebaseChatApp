import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final _messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? _editingMessageId;
  bool _isEditing = false;

  final String _statusSending = 'sending';
  final String _statusSent = 'sent';
  final String _statusDelivered = 'delivered';
  final String _statusSeen = 'seen';

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final user = _auth.currentUser;
    if (user == null) return;

    if (_isEditing) {
      // Edit existing message
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
        'senderName': user.displayName ?? 'Unknown',
        'timestamp': FieldValue.serverTimestamp(),
        'status': _statusSending,
      });

      await messageDocRef.update({'status': _statusSent});
    }

    _messageController.clear();
  }

  void _markMessageAsSeen(String messageId) async {
    await _firestore.collection('messages').doc(messageId).update({
      'status': _statusSeen,
    });
  }

  void _deleteMessage(String messageId) async {
    await _firestore.collection('messages').doc(messageId).delete();
  }

  void _editMessage(String messageId, String text) {
    setState(() {
      _messageController.text = text;
      _isEditing = true;
      _editingMessageId = messageId;
    });
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "";
    return DateFormat('hh:mm a').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = _auth.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Chats"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index].data() as Map<String, dynamic>;
                    final messageId = messages[index].id;
                    final isMe = message['sender'] == userEmail;
                    final status = message['status'] ?? _statusSending;
                    final timestamp = message['timestamp'] as Timestamp?;
                    final senderName = message['sender'] ?? 'Unknown';
                    final isEdited = message['edited'] ?? false;

                    if (!isMe) {
                      _markMessageAsSeen(messageId);
                    }

                    return Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12, top: 5),
                          child: Row(
                            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              Text(
                                isMe ? "You" : senderName,
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: isMe ? Colors.blueGrey : Colors.black54,
                                ),
                              ),
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
                          padding: const EdgeInsets.only(right: 12),
                          child: Row(
                            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(left: isMe ? 0 : 16),
                                child: Text(
                                  _formatTimestamp(timestamp),
                                  style: const TextStyle(fontSize: 8, color: Colors.black54),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(isEdited ? 'Edited' : '',style: const TextStyle(fontSize: 8),),
                              const SizedBox(width: 4),
                              if (isMe) ...[
                                if (status == _statusSending)
                                  const Icon(Icons.access_time, size: 14, color: Colors.orange),
                                if (status == _statusSent)
                                  const Icon(Icons.check, size: 14, color: Colors.blue),
                                if (status == _statusDelivered)
                                  const Icon(Icons.done_all, size: 14, color: Colors.green),
                                if (status == _statusSeen)
                                  const Icon(Icons.done_all, size: 14, color: Colors.blueAccent),
                              ],
                            ],
                          ),
                        )

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
        if (value == 'Edit') {
          _editMessage(messageId, messageText);
        } else if (value == 'Delete') {
          _deleteMessage(messageId);
        }
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
