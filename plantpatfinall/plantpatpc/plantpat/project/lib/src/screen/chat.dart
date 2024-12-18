import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatBubble> _messages = [];
  final ImagePicker _picker = ImagePicker();
  bool _messageSent = false;
  StreamSubscription<QuerySnapshot>? _messageSubscription;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _listenToMessages();
  }

  @override
  void dispose() {
  
    _messageSubscription?.cancel();
   
    super.dispose();
  }

  void _sendMessage({String? text, File? image}) async {
    if (text != null && text.isNotEmpty) {
      await _sendMessageToFirestore(text: text);
      _messageController.clear();
    } else if (image != null) {
      String imageUrl = await _uploadImageAndSendMessage(image: image);
      await _sendMessageToFirestore(text: '', imageUrl: imageUrl);
    }

    if (!_messageSent) {
    
      Future.delayed(Duration(seconds: 1), () async {
        await _sendWelcomeMessage();
      });
      _messageSent = true;
    }
  }

  Future<void> _sendWelcomeMessage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String userId = user.uid;
    final String receiverId = "uEIkbXccWBXZsJ0oBEV3NmrrYp03"; 

    List<String> ids = [userId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    final chatRoomDoc = FirebaseFirestore.instance.collection('The_chat_rooms').doc(chatRoomId);

    try {
     
      final docSnapshot = await chatRoomDoc.get();
      final data = docSnapshot.data() as Map<String, dynamic>?;

      if (data != null && data['welcomeMessageSent'] != true) {
        await _sendMessageToFirestore(text: 'Hello, thanks for texting. We will connect you soon.');
        await chatRoomDoc.update({'welcomeMessageSent': true});
        print("Welcome message sent successfully");
      }
    } catch (error) {
      print("Failed to send welcome message: $error");
    }
  }

  Future<void> _sendMessageToFirestore({required String text, String? imageUrl}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String userId = user.uid;
    String currentUserEmail = user.email ?? '';
    final Timestamp timestamp = Timestamp.now();
    final String receiverId = "uEIkbXccWBXZsJ0oBEV3NmrrYp03"; 

    Message newMessage = Message(
      senderId: userId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: text,
      imageUrl: imageUrl,
      timestamp: timestamp,
    );

    List<String> ids = [userId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    try {
      await FirebaseFirestore.instance
          .collection('The_chat_rooms')
          .doc(chatRoomId)
          .collection('The_messages')
          .add(newMessage.toMap());
      print("Message sent successfully");
    } catch (error) {
      print("Failed to send message: $error");
    }
  }

  Future<String> _uploadImageAndSendMessage({required File image}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return '';

    try {
      
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = _storage.ref().child('chat_images/$fileName');

    
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() => {});
      final imageUrl = await snapshot.ref.getDownloadURL();
      print("Image URL: $imageUrl");

      return imageUrl;
    } catch (e) {
      print('Failed to upload image and send message: $e');
      return '';
    }
  }

  void _listenToMessages() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String userId = user.uid;
    final String receiverId = "uEIkbXccWBXZsJ0oBEV3NmrrYp03"; 

    List<String> ids = [userId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    _messageSubscription = FirebaseFirestore.instance
        .collection('The_chat_rooms')
        .doc(chatRoomId)
        .collection('The_messages')
        .orderBy('timestamp') 
        .snapshots()
        .listen((snapshot) {
      if (mounted) {
        setState(() {
          _messages.clear();
          _messages.addAll(snapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>;

                final String? text = data['message'] as String?;
                final String? imageUrl = data.containsKey('imageUrl') ? data['imageUrl'] as String? : null;

                return ChatBubble(
                  text: text,
                  imageUrl: imageUrl,
                  isSentByMe: data['senderId'] == userId,
                  time: (data['timestamp'] as Timestamp).toDate().toString(),
                );
              })
              .toList());
        });
      }
    }, onError: (error) {
      print("Error in message stream: $error");
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _sendMessage(image: File(pickedFile.path));
    }
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
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '71'.tr,
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  '72'.tr,
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.photo, color: Colors.green),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: '73'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green),
                  onPressed: () {
                    final text = _messageController.text;
                    if (text.isNotEmpty) {
                      _sendMessage(text: text);
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

// class ChatBubble extends StatelessWidget {
//   final String? text;
//   final String? imageUrl;
//   final bool isSentByMe;
//   final String time;

//   ChatBubble({
//     this.text,
//     this.imageUrl,
//     required this.isSentByMe,
//     required this.time,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 5),
//       child: Row(
//         mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (imageUrl != null && imageUrl!.isNotEmpty) ...[
//             Container(
//               margin: EdgeInsets.only(bottom: 5),
//               constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width * 0.6,
//                 maxHeight: 200, // Limit the height of images
//               ),
//               child: Image.network(
//                 imageUrl!,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     color: Colors.grey[300],
//                     child: Center(child: Text('Image failed to load')),
//                   );
//                 },
//               ),
//             ),
//           ],
//           if (text != null && text!.isNotEmpty) ...[
//             Flexible(
//               child: Container(
//                 padding: EdgeInsets.all(8),
                
//                 decoration: BoxDecoration(
//                   color: isSentByMe ? Colors.green : Colors.grey[300],
//                    borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       text!,
//                       style: TextStyle(color: isSentByMe ? Colors.white : Colors.black),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       time,
//                       style: TextStyle(fontSize: 12, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }


class ChatBubble extends StatelessWidget {
  final String? text;
  final String? imageUrl;
  final bool isSentByMe;
  final String time;

  ChatBubble({
    this.text,
    this.imageUrl,
    required this.isSentByMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10), 
      child: Row(
        mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null && imageUrl!.isNotEmpty) ...[
            Container(
              margin: EdgeInsets.only(bottom: 10), 
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6,
                maxHeight: 250, 
              ),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(child: Text('Image failed to load')),
                  );
                },
              ),
            ),
          ],
          if (text != null && text!.isNotEmpty) ...[
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
                    text!,
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




class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final String? imageUrl;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    this.imageUrl,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
    };
  }
}