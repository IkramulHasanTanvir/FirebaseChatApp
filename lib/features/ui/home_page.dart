// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.amber,
//         title: const Text(
//           "Chats",
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 24),
//           // Recent chats / active users
//           SizedBox(
//             height: 90,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: 10,
//               itemBuilder: (context, index) {
//                 //var userData = users[index].data() as Map<String, dynamic>;
//                 return const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 32,
//                         backgroundImage: NetworkImage(''),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         'Unknown',
//                         style: TextStyle(fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//             /*StreamBuilder<QuerySnapshot>(
//               stream: _firestore.collection('users').snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return const Center(child: Text("Error loading users"));
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text("No users found"));
//                 }
//                 var users = snapshot.data!.docs;
//                 return
//               },
//             ),*/
//           ),
//           Divider(color: Colors.grey.withOpacity(0.2), thickness: 8),
//
//           // All users list
//           Expanded(
//             child: ListView.separated(
//               itemCount: 10,
//               itemBuilder: (context, index) {
//                // var userData = users[index].data() as Map<String, dynamic>;
//                 return ListTile(
//                   leading: const CircleAvatar(
//                     radius: 24,
//                     backgroundImage:NetworkImage(''),
//                     child:Icon(Icons.person)
//                   ),
//                   title: const Text('Unknown',
//                     style: TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                   onTap: () {
//                     // Navigate to chat screen
//                   },
//                 );
//               },
//               separatorBuilder: (context, index) => Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Divider(color: Colors.grey.withOpacity(0.2)),
//               ),
//             ),
//             /*StreamBuilder<QuerySnapshot>(
//               stream: _firestore.collection('users').snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return const Center(child: Text("Error loading chats"));
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text("No chats available"));
//                 }
//                 var users = snapshot.data!.docs;
//                 return
//               },
//             ),*/
//           ),
//         ],
//       ),
//     );
//   }
// }
