// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:googleapis/androidpublisher/v3.dart';
// import 'package:plantpat/src/screen/chat_ad.dart';

// // Define your ChatBubble class
// class ChatBubble {
//   final String? text;
//   //final String? image;
//   final bool isSentByMe;
//   final String? time;

//   ChatBubble({
//     this.text,
//    // this.image,
//     required this.isSentByMe,
//     this.time,
//   });
// }

// // Define SubChat as a StatefulWidget
// class SubChat extends StatefulWidget {
//   final List<ChatBubble> messages;
//   final Contact? contact;

//   SubChat({
//     required this.messages,
//     this.contact,
//   });

//   @override
//   _SubChatState createState() => _SubChatState();
// }

// class _SubChatState extends State<SubChat> {
//   final TextEditingController _messageController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     print("in build::::::::::::::::::::::::::::::::::::::::::");
//     print(widget.messages.length);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Row(
//           children: [
//             SizedBox(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.contact?.name ?? 'Technical Support',
//                   style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   'Available now',
//                   style: TextStyle(color: Colors.green, fontSize: 12),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       drawer: AppDrawer(),
//       body: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     reverse: true, // To show the most recent messages at the bottom
//                     padding: EdgeInsets.all(16),
//                     itemCount: widget.messages.length,
//                     itemBuilder: (context, index) {
//                       final message = widget.messages[index];
//                       return ChatBubbleWidget(
//                         text: message.text ?? '',
//                         image: message.image,
//                         isSentByMe: message.isSentByMe,
//                         time: message.time ?? '',
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.camera_alt, color: Colors.green),
//                         onPressed: _pickImage,
//                       ),
//                       Expanded(
//                         child: TextField(
//                           controller: _messageController,
//                           decoration: InputDecoration(
//                             hintText: 'Write your message',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       CircleAvatar(
//                         backgroundColor: Colors.green,
//                         child: IconButton(
//                           icon: Icon(Icons.send, color: Colors.white),
//                           onPressed: () => _sendMessage(text: _messageController.text),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           VerticalDivider(width: 1),
//           Expanded(
//             flex: 1,
//             child: FutureBuilder<List<Contact>>(
//               future: _fetchContacts(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(child: Text('No contacts available'));
//                 } else {
//                   final contacts = snapshot.data!;
//                   return ContactsList(
//                     contacts: contacts,
//                     onContactSelected: (contact) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ChatPage(contact: contact),
//                         ),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _pickImage() async {
//     // Implement image picking functionality
//   }

//   Future<void> _sendMessage({required String text}) async {
//     // Implement sending message functionality
//   }

//   Future<List<Contact>> _fetchContacts() async {
//     // Implement fetching contacts functionality
//     return []; // Placeholder
//   }
// }

// // Define the Contact class
// class Contact {
//   final String name;

//   Contact(this.name);
// }

// // Define the ChatBubbleWidget, AppDrawer, ContactsList, and ChatPage as needed
// class ChatBubbleWidget extends StatelessWidget {
//   final String text;
//   final String? image;
//   final bool isSentByMe;
//   final String time;

//   ChatBubbleWidget({
//     required this.text,
//     this.image,
//     required this.isSentByMe,
//     required this.time,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Implement the ChatBubbleWidget build method
//     return Container();
//   }
// }


// class AppDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//             child: Text('Drawer Header'),
//             decoration: BoxDecoration(
//               color: Colors.blue,
//             ),
//           ),
//           ListTile(
//             title: Text('Item 1'),
//             onTap: () {
//               // Handle item tap
//             },
//           ),
//           ListTile(
//             title: Text('Item 2'),
//             onTap: () {
//               // Handle item tap
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }



// class ChatService {
//   static Future<List<ChatBubble>> fetchMessages(String senderId) async {
//     try {
//       List<String> ids = [senderId, "uEIkbXccWBXZsJ0oBEV3NmrrYp03"];
//       ids.sort();
//       String chatRoomId = ids.join("_");

//       print('Attempting to fetch chat room with ID: $chatRoomId');

//       QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
//           .collection('The_chat_rooms')
//           .doc(chatRoomId)
//           .collection('The_messages')
//           .orderBy('timestamp', descending: true) // Ensure sorting by timestamp
//           .get();

//       if (messagesSnapshot.docs.isEmpty) {
//         print('No messages found for chat room: $chatRoomId');
//         return [];
//       } else {
//         print('Messages Snapshot: ${messagesSnapshot.docs.length} documents found.');

//         List<ChatBubble> messages = messagesSnapshot.docs.map((doc) {
//           var messageData = doc.data() as Map<String, dynamic>;
//           bool isSentByMe = messageData['senderId'] == FirebaseAuth.instance.currentUser?.uid;
//           return ChatBubble(
//             text: messageData['message'],
//             image: messageData['imageUrl'] != null ? "": null,
//             isSentByMe: isSentByMe,
//             time: _formatTime(messageData['timestamp']),
//           );
//         }).toList();

//         // Print only the message text in the order they are fetched
//         for (var message in messages) {
//           print('Message: ${message.text}');
//         }

//         return messages;
//       }
//     } catch (e) {
//       print('Error fetching chat room or messages: $e');
//       return [];
//     }
//   }

//   // Helper method to format time if needed
//   static String _formatTime(Timestamp timestamp) {
//     // Implement your time formatting logic
//     return timestamp.toDate().toString();
//   }
// }