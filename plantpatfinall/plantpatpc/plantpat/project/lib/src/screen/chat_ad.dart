// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:googleapis/vision/v1.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:plantpat/src/screen/contact.dart';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';


class ChatRoomPage extends StatefulWidget {
  final Contact contact;
  final String chatRoomId; 

  ChatRoomPage({required this.contact, required this.chatRoomId});

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  List<ChatBubble> _messages = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    bool _messageSent = false;


  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }





             ImageProvider _getImageProvider(String name) {
    if (name == 'lujain darwazeh') {
      print("LUJAIN");
      return AssetImage('assets/images/lujain.jpg');
    } else if (name == 'rama darwazeh') {
       print("RAMA");
      return AssetImage('assets/images/rama.jpg');
    } else if (name == 'aya awwad') {
       print("AYA");
      return AssetImage('assets/images/aya.jpg');
    } else {
      print("name::::::::::$name");
      return AssetImage('assets/images/nohuman.png'); 
    }
  }
  Future<void> _fetchMessages() async {
    try {
      String chatRoomId = widget.chatRoomId;
     // print('Attempting to fetch chat room with ID: $chatRoomId');

      QuerySnapshot messagesSnapshot = await _firestore
          .collection('The_chat_rooms')
          .doc(chatRoomId)
          .collection('The_messages')
          .orderBy('timestamp', descending: true)
          .get();

      if (messagesSnapshot.docs.isEmpty) {
        print('No messages found for chat room: $chatRoomId');
        setState(() {
          _messages = [];
        });
        return;
      } else {
        print('Messages Snapshot: ${messagesSnapshot.docs.length} documents found.');

        List<ChatBubble> messages = messagesSnapshot.docs.map((doc) {
          var messageData = doc.data() as Map<String, dynamic>;
          bool isSentByMe = messageData['senderId'] == FirebaseAuth.instance.currentUser?.uid;
         // print("helllllo");
        //  print(messageData['imageUrl']);
          return ChatBubble(
            text: messageData['message'],
            imageUrl: messageData['imageUrl'] ,
            isSentByMe: isSentByMe,
            time: _formatTime(messageData['timestamp']),
          );
        }).toList();

        setState(() {
          _messages = messages;
        });

        for (var message in messages) {
          print('Message: ${message.text}');
        }
      }
    } catch (e) {
      print('Error fetching chat room or messages: $e');
    }
  }

  String _formatTime(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    return '${dateTime.hour}:${dateTime.minute}';
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: _getImageProvider(widget.contact.name),
            radius: 20, 
          ),
          SizedBox(width: 10), 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.contact.name,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Text(
                'Available now',
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    ),
    body: Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return _messages[index];
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.photo, color: Colors.green),
                onPressed: _pickImage,
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.green,
                child: IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: () => _sendMessage(text: _messageController.text),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  
  void _sendMessagee({String? text, File? image}) async {
  
    if (text != null && text.isNotEmpty) {
   
      await _sendMessage(text:text);

 
    
      _messageController.clear();
     setState(() {
  _fetchMessages();
});

    } else if (image != null) {
     
    }


  }
  final ImagePicker _picker = ImagePicker();

   Future<void> _pickImage() async {
    // final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   _sendMessage(image: File(pickedFile.path));
    // }
  }

Future<void> _sendMessage({required String text, String? imageUrl}) async {
  try {
    if (_messageController.text.isNotEmpty) {
     
      final parts = widget.chatRoomId.split('_');
      final receiverId = parts[0]; 
      final senderId = FirebaseAuth.instance.currentUser?.uid; 

      await _firestore.collection('The_chat_rooms')
        .doc(widget.chatRoomId)
        .collection('The_messages')
        .add({
          'message': _messageController.text,
          'senderId': senderId,
          'timestamp': FieldValue.serverTimestamp(),
          'receiverId': receiverId, 
        });

      setState(() {
        _messageController.clear();
      });
    }
  } catch (e) {
    print('Error sending message: $e');
  }
}


}

class ChatBubble extends StatelessWidget {
  final String text;
  final String? imageUrl;
  final bool isSentByMe;
  final String time;

  ChatBubble({
    required this.text,
    this.imageUrl,
    required this.isSentByMe,
    required this.time,
  });

Future<String> getImageUrl(String imagePath) async {
  print("Fetching image URL for path: $imagePath");  
  try {
    final ref = FirebaseStorage.instance.ref().child(imagePath);
    final url = await ref.getDownloadURL();
    print("Successfully fetched image URL: $url");  
    return url;
  } catch (e) {
    print("Error getting image URL: $e");  
    return '';
  }
}



//   @override
// Widget build(BuildContext context) {
//   print("Building ChatBubble with imageUrl: $imageUrl");  // Print the image URL provided

//   final imageUrlToUse = imageUrl;

//   return Container(
//     margin: EdgeInsets.symmetric(vertical: 10),
//     child: Row(
//       mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (imageUrlToUse != null && imageUrlToUse.isNotEmpty) ...[
//           FutureBuilder<String>(
//             future: getImageUrl(imageUrlToUse),
//             builder: (context, snapshot) {
//               print("FutureBuilder state: ${snapshot.connectionState}");  // Print the connection state

//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 print("Loading image...");  // Print when loading
//                 return Container(
//                   margin: EdgeInsets.only(bottom: 10),
//                   constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.6,
//                     maxHeight: 250,
//                   ),
//                   child: Center(child: CircularProgressIndicator()),
//                 );
//               } else if (snapshot.hasError) {
//                 print("Error loading image: ${snapshot.error}");  // Print the error
//                 return Container(
//                   margin: EdgeInsets.only(bottom: 10),
//                   constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.6,
//                     maxHeight: 250,
//                   ),
//                   child: Center(child: Text('Failed to load image')),
//                 );
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 print("Image URL is empty");  // Print if no data or empty URL
//                 return Container(
//                   margin: EdgeInsets.only(bottom: 10),
//                   constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.6,
//                     maxHeight: 250,
//                   ),
//                   child: Center(child: Text('Image not available')),
//                 );
//               } else {
//                 final imageUrl = snapshot.data!;
//                 print("Loaded image URL: $imageUrl");  // Print the loaded image URL
//                 return Container(
//                   margin: EdgeInsets.only(bottom: 10),
//                   constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.6,
//                     maxHeight: 250,
//                   ),
//                   child: Image.network(
//                     imageUrl,
//                     fit: BoxFit.cover,
//                     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
//                       if (loadingProgress == null) {
//                         return child;
//                       } else {
//                         print("Loading image progress: ${loadingProgress.cumulativeBytesLoaded}/${loadingProgress.expectedTotalBytes}");  // Print loading progress
//                         return Center(
//                           child: CircularProgressIndicator(
//                             value: loadingProgress.expectedTotalBytes != null
//                                 ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
//                                 : null,
//                           ),
//                         );
//                       }
//                     },
//                     errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
//                       print("Error loading image: $error");  // Print image loading error
//                       print("Stack trace: $stackTrace");  // Print stack trace
//                       return Center(child: Text('Failed to load image'));
//                     },
//                   ),
//                 );
//               }
//             },
//           ),
//         ],
//         if (text.isNotEmpty) ...[
//           Column(
//             crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(16),
//                 constraints: BoxConstraints(
//                   maxWidth: MediaQuery.of(context).size.width * 0.7,
//                 ),
//                 decoration: BoxDecoration(
//                   color: isSentByMe ? Colors.green : Colors.grey[300],
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   text,
//                   style: TextStyle(
//                     color: isSentByMe ? Colors.white : Colors.black,
//                     fontSize: 16,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 time,
//                 style: TextStyle(color: Colors.grey, fontSize: 14),
//               ),
//             ],
//           ),
//         ],
//       ],
//     ),
//   );
// }







Widget build(BuildContext context) {
  print("Building ChatBubble with local image: assets/images/17.jpg");

  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       
        if (text.isEmpty) ...[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
              maxHeight: 250,
            ),
            child: Image.asset(
              'assets/images/p2.png',
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                print("Error loading local image: $error");  
                print("Stack trace: $stackTrace");  
                return Center(child: Text('Failed to load image'));
              },
            ),
          ),
        ],

      
        if (text.isNotEmpty) ...[
          Column(
            crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                decoration: BoxDecoration(
                  color: isSentByMe ? Colors.green : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isSentByMe ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 8),
              Text(
                time,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}



}













// class ChatListPage extends StatelessWidget {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chats'),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: FutureBuilder<List<Contact>>(
//         future: _fetchContacts(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No contacts available'));
//           } else {
//             List<Contact> contacts = snapshot.data!;
//             return ListView.builder(
//               itemCount: contacts.length,
//               itemBuilder: (context, index) {
//                 final contact = contacts[index];
//                 String chatRoomId = '${_auth.currentUser!.uid}_${contact.id}';
//                 chatRoomId = chatRoomId.compareTo('${contact.id}_${_auth.currentUser!.uid}') < 0
//                   ? chatRoomId
//                   : '${contact.id}_${_auth.currentUser!.uid}';

//                 return ListTile(
//                   title: Text(contact.name),
//                  // subtitle: Text(contact.lastMessage),
//                  // trailing: Text(contact.time),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ChatRoomPage(
//                           contact: contact,
//                           chatRoomId: chatRoomId, // Pass chatRoomId
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
