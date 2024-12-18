import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import'package:plantpat/model/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = auth.currentUser!.uid;
    final String currentUserEmail = auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        recevierId: receiverId,
        message: message,
        timestamp: timestamp);

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await fireStore
        .collection('The_chat_rooms')
        .doc(chatRoomId)
        .collection('The_messages')
        .add(newMessage.toMap());
  }

  Future<void> saveUserTookToIt(int theId, String id, String email,
      String first, String last, int idOfSeller) async {
    final String currentUserId = auth.currentUser!.uid;
    final String currentUserEmail = auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await fireStore
          .collection('saveUserTookToIt')
          .doc(theId.toString())
          .collection('msg')
          .doc(idOfSeller.toString())
          .set({
        'uid': id,
        'email': email,
        'first_name': first,
        'last_name': last,
        'id_of_user': idOfSeller,
      }, SetOptions(merge: true));
      /*  firestore.collection('saveUserTookToIt').doc(id).set({
        'uid': id,
        'email': email,
        'first_name': first,
        'last_name': last,
        'id_of_user': idOfSeller,
      }, SetOptions(merge: true));*/
    } catch (e) {
      print(e);
    }
    /*  Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        recevierId: receiverId,
        message: message,
        timestamp: timestamp);

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await fireStore
        .collection('The_chat_rooms')
        .doc(chatRoomId)
        .collection('The_messages')
        .add(newMessage.toMap());*/
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return fireStore
        .collection('The_chat_rooms')
        .doc(chatRoomId)
        .collection('The_messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

////////////////////////////////////////////////////////////////////
/*  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getChatRoomsForUser(String userId) {
    return _firestore
        .collection('chat_rooms')
        .where('messages', arrayContains: userId)
        .snapshots();
  }

  Future<List<String>> getUsersWithChatHistory() async {
    final String currentUserId = auth.currentUser!.uid;
    List<String> usersWithChatHistory = [];

    QuerySnapshot chatRoomsSnapshot = await fireStore
        .collection('chat_rooms')
        .where('messages', arrayContains: currentUserId)
        .get();

    for (QueryDocumentSnapshot roomSnapshot in chatRoomsSnapshot.docs) {
      List<dynamic> participants = roomSnapshot['messages'];
      List<String> participantsStrings =
          participants.cast<String>(); // Cast to List<String>
      participantsStrings
          .remove(currentUserId); // Remove current user from participants
      usersWithChatHistory.addAll(participantsStrings);
    }

    return usersWithChatHistory.toSet().toList(); // Remove duplicates
  }*/
}
