import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_real_time_data/common/custom_navigator.dart';
import 'package:firebase_real_time_data/features/auth/login_page.dart';
import 'package:firebase_real_time_data/features/ui/chats_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _name = "";
  String _email = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }
  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _name = userDoc['name'] ?? 'Unknown';
          _email = userDoc['email'] ?? 'No Email';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.amber,
        title: const Text(
          "Chats",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.amber),
              accountName: Text(
                _name.toUpperCase(),
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              accountEmail: Text(
                _email,
                style: const TextStyle(color: Colors.black),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, size: 40, color: Colors.grey),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.messenger),
              title: const Text('Chats'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await _auth.signOut();
                if (mounted) {
                  customNavigatorPushRemoveAll(context, const LoginPage());
                }
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          SizedBox(
            height: 90,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading users"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No users found"));
                }

                var users = snapshot.data!.docs;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var userData = users[index].data() as Map<String, dynamic>;
                    String chatPartnerName = userData['name'] ?? 'Unknown';
                    String chatPartnerId = userData['uid'] ?? 'Unknown';
                    return GestureDetector(
                      onTap: (){
                        customNavigatorPush(context,  ChatsPage(chatPartnerId: chatPartnerId, chatPartnerName: chatPartnerName,));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.grey.shade300,
                              child: const Icon(Icons.person, size: 44,color: Colors.grey,),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userData['name'] ?? 'Unknown',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Divider(color: Colors.grey.withOpacity(0.2), thickness: 8),

          // All Users List
        ],
      ),
    );
  }
}
