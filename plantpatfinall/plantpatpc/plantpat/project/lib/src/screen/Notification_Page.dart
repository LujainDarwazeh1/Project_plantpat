
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plantpat/src/screen/RatingPage.dart';
import 'package:plantpat/src/screen/mapFreepickuppoint.dart';
import 'package:plantpat/src/screen/notification_send_msg.dart';
import 'package:plantpat/src/screen/prod_info.dart';
import 'package:plantpat/src/screen/shopping_cart.dart';
import 'package:plantpat/src/screen/userdetails.dart';
import 'package:plantpat/src/screen/order_tracking_page.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _allRead = false;
  List<Map<String, dynamic>> notifications = [];
  late String userId;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      print("User is authenticated: $userId");
      getNotificationsForCurrentUser();
    } else {
      userId = '';
    }
  }

  Future<void> getNotificationsForCurrentUser() async {
    if (userId.isEmpty) {
      print("User is not authenticated");
      return;
    }

    try {
      print("Fetching notifications for UID: $userId");
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('notifications')
          .doc(userId)
          .collection('userNotifications')
          .orderBy('timestamp', descending: true)
          .get();

      print("Number of notifications fetched: ${snapshot.docs.length}");

      setState(() {
        notifications = snapshot.docs.map((doc) {
          var data = doc.data();
          data['id'] = doc.id; 
          return data;
        }).toList();
      });

      print("Notifications fetched successfully");
    } catch (e) {
      print('Failed to fetch notifications: $e');
    }
  }

  Future<void> markAsRead(String docId) async {
    if (userId.isEmpty) return;

    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(userId)
          .collection('userNotifications')
          .doc(docId)
          .update({'isRead': true});
    } catch (e) {
      print('Failed to mark notification as read: $e');
    }
  }

  Future<void> deleteNotification(int index, String docId) async {
    if (userId.isEmpty) return;

    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(userId)
          .collection('userNotifications')
          .doc(docId)
          .delete();

      setState(() {
        notifications.removeAt(index);
      });

      print('Notification deleted successfully');
    } catch (e) {
      print('Failed to delete notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
print("userrrrrrrrrrrid::::::::::");
    print(userId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Notifications', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.done, color: Colors.black),
            onPressed: () {
              setState(() {
                _allRead = true; 
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .doc(userId)
            .collection('userNotifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final notifications = snapshot.data?.docs ?? [];
          return notifications.isEmpty
              ? Center(child: Text('No notifications available.'))
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification =
                        notifications[index].data() as Map<String, dynamic>;
                    final docId = notifications[index].id;
                    return GestureDetector(
                      onTap: () async {
                       
                        if (notification['title'] == 'Private Reminder') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartPage(),
                            ),
                          );
                        } else if (notification['title'] == 'Order Track') {
      print("hello..........................");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderTrackingPage(),
        ),
      );
    }
                         if (notifications[index]['title'] == 'Rating product') {
  print("plant id :::::::::::::::");

  print(CartPageState.idsplant);


  List<int> uniquePlantIds = CartPageState.idsplant.toSet().toList();

  print("Unique plant id :::::::::::::::");

  print(uniquePlantIds);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RatingPage(
        plantIds: uniquePlantIds,
      ),
    ),
  );
}

    else if (notification['title'] == 'Free pick up point') {
      print("hello..........................");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapFreePickUpPoint(),
        ),
      );
    }

    else if (notification['title'] ==
                            'New Order Received') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailsPage(
                                amount: (notification['amount'] as num?)
                                        ?.toDouble() ??
                                    0.0,
                                userEmail: notification['userEmail'] ?? '',
                                firstName: notification['firstName'] ?? '',
                                lastName: notification['lastName'] ?? '',
                                city: notification['city'] ?? '',
                                street: notification['street'] ?? '',
                                userPhone: notification['userPhone'] ?? '',
                                userid: notification['userid'] ?? '',
                                payment_method:notification['payment_method'] ?? '',

                              ),
                            ),
                          );
                        } else if (notification['title'] == 'New Collection') {
                          print('**** itemsToNotify $productFromNotificaiom');
                          print('**** idx $idx');

                          
                          if (productFromNotificaiom.isNotEmpty &&
                              idx >= 0 &&
                              idx < productFromNotificaiom.length) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  size: productFromNotificaiom[idx]['size'],
                                  imagePaths: productFromNotificaiom[idx]
                                      ['image'],
                                  price: productFromNotificaiom[idx]['price'],
                                  plantId: productFromNotificaiom[idx]['id'],
                                  avgRate: productFromNotificaiom[idx]
                                      ['average_rating'],
                                  height: productFromNotificaiom[idx]['height'],
                                  sectionid: productFromNotificaiom[idx]
                                      ['sectionid'],
                                  quantity: productFromNotificaiom[idx]
                                      ['quantity'],
                                  name: productFromNotificaiom[idx]['name'],
                                  description: productFromNotificaiom[idx]
                                      ['description'],
                                ),
                              ),
                            );
                          } else {
                            print(
                                'Invalid index or empty list. productFromNotificaiom length: ${productFromNotificaiom.length}, idx: $idx');
                          }
                        }
   

                        
                        await markAsRead(docId);

                        setState(() {
                         
                        });
                      },
                      child: Container(
                        color: notification['isRead'] == true
                            ? Colors.white
                            : Colors.green.withOpacity(0.2),
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          title: Text(
                            notification['title'],
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(notification['body']),
                              SizedBox(height: 5),
                              Text(
                                notification['timestamp'] != null
                                    ? (notification['timestamp'] as Timestamp)
                                        .toDate()
                                        .toString()
                                    : 'N/A',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<int>(
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.grey,
                            ),
                            onSelected: (value) {
                              if (value == 1) {
                                deleteNotification(index, docId);
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<int>>[
                              PopupMenuItem<int>(
                                value: 1,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.close,
                                      color: Colors.green,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Remove this notification',
                                      style: GoogleFonts.aBeeZee(
                                        textStyle: TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
