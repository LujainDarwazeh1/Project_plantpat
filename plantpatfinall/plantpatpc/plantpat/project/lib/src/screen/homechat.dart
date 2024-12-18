import 'dart:math';
import 'package:flutter/material.dart';
import 'package:plantpat/src/screen/HomeAdmin.dart';
import 'package:plantpat/src/screen/chat_ad.dart';
import 'package:plantpat/src/screen/contact.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeChat extends StatefulWidget {
  final List<Contact> contacts;

  HomeChat({required this.contacts});

  @override
  _HomeChatState createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  late List<int> unreadCounts;
  late List<DateTime> dates; 

  @override
  void initState() {
    super.initState();
    unreadCounts = _generateRandomUnreadCounts(widget.contacts); 
    dates = _generateSpecificDates(widget.contacts.length); 
  }

  ImageProvider _getImageProvider(String name) {
    if (name == 'lujain darwazeh') {
      return AssetImage('assets/images/lujain.jpg');
    } else if (name == 'rama darwazeh') {
      return AssetImage('assets/images/rama.jpg');
    } else if (name == 'aya awwad') {
      return AssetImage('assets/images/aya.jpg');
    } else {
      return AssetImage('assets/images/nohuman.png'); 
    }
  }

  @override
  Widget build(BuildContext context) {
  
    List<Contact> sortedContacts = List.from(widget.contacts);
    sortedContacts.sort((a, b) {
      if (a.name.toLowerCase().trim() == "lujain darwazeh") {
        return -1;
      } else if (b.name.toLowerCase().trim() == "lujain darwazeh") {
        return 1;
      }
      return 0;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Here...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sortedContacts.length,
              itemBuilder: (context, index) {
                final contact = sortedContacts[index];
                String currentUserId = FirebaseAuth.instance.currentUser!.uid;
                String contactId = contact.id;

                
                List<String> ids = [currentUserId, contactId];
                ids.sort();
                String chatRoomId = ids.join("_");

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: contact.name.toLowerCase().trim() == "lujain darwazeh"
                        ? AssetImage('assets/images/lujain.jpg')
                        : _getImageProvider(contact.name),
                  ),
                  title: Container(
                    constraints: BoxConstraints(maxWidth: 200), 
                    child: Text(
                      contact.name,
                      overflow: TextOverflow.ellipsis, 
                    ),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(width: 10), 
                      Text(
                        "${dates[index].toLocal()}".split(' ')[0], 
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 4),
                      if (unreadCounts[index] > 0)
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${unreadCounts[index]}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoomPage(
                          contact: contact,
                          chatRoomId: chatRoomId,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<DateTime> _generateSpecificDates(int count) {
    List<DateTime> dates = [
      DateTime(DateTime.now().year, 9, 3), // August 13
      DateTime(DateTime.now().year, 8, 9),  // August 9
      DateTime(DateTime.now().year, 8, 7),  // August 7
      DateTime(DateTime.now().year, 8, 7),  // August 7
      DateTime(DateTime.now().year, 8, 7)   // August 7
    ];

    
    if (dates.length > count) {
      dates = dates.take(count).toList();
    } else if (dates.length < count) {
      DateTime lastDate = dates.last;
      while (dates.length < count) {
        lastDate = lastDate.subtract(Duration(days: 1));
        dates.add(lastDate);
      }
    }

    return dates;
  }

  List<int> _generateRandomUnreadCounts(List<Contact> contacts) {
    List<int> unreadCounts = [];
    Random random = Random();

    for (int i = 0; i < contacts.length; i++) {
      if (i == 0) {
        // Ensure that the unread count is 4 for the first contact in the list
        
       // unreadCounts.add(6);
        unreadCounts.add(0);

      } else if (i == contacts.length - 1) {
        // Ensure that the unread count is 0 for the last contact in the list
        unreadCounts.add(0);
      } else {
        // Random unread count between 1 and 2 for other contacts
        unreadCounts.add(random.nextInt(2) + 1);
      }
    }

    return unreadCounts;
  }
}







// import 'package:flutter/material.dart';
// import 'package:plantpat/src/screen/HomeAdmin.dart';
// import 'package:plantpat/src/screen/chat_ad.dart';
// import 'package:plantpat/src/screen/contact.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:math'; // For generating random numbers

// class HomeChat extends StatefulWidget {
//   final List<Contact> contacts;

//   HomeChat({required this.contacts});

//   @override
//   _HomeChatState createState() => _HomeChatState();
// }

// class _HomeChatState extends State<HomeChat> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   ImageProvider _getImageProvider(String name) {
//     if (name == 'lujain darwazeh') {
//       print("LUJAIN");
//       return AssetImage('assets/images/lujain.jpg');
//     } else if (name == 'rama darwazeh') {
//        print("RAMA");
//       return AssetImage('assets/images/rama.jpg');
//     } else if (name == 'aya awwad') {
//        print("AYA");
//       return AssetImage('assets/images/aya.jpg');
//     } else {
//       print("name::::::::::$name");
//       return AssetImage('assets/images/nohuman.png'); // Ensure this image also exists
//     }
//   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(

// //         title: Text('Chats'),
// //         backgroundColor: Colors.green,
        
// //         elevation: 0,
// //       ),
// //        drawer: AppDrawer(), 
// //       body: Column(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: TextField(
// //               decoration: InputDecoration(
// //                 hintText: 'Search Here...',
// //                 prefixIcon: Icon(Icons.search),
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(20),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: widget.contacts.length,
// //               itemBuilder: (context, index) {
// //                 final contact = widget.contacts[index];
// //                 String currentUserId = FirebaseAuth.instance.currentUser!.uid;
// //                 String contactId = contact.id;

// //                 // Generate chatRoomId by combining user and contact IDs
// //                 List<String> ids = [currentUserId, contactId];
// //                 ids.sort();
// //                 String chatRoomId = ids.join("_");

// //                 return ListTile(
// //                   leading: CircleAvatar(
// //                     backgroundImage: _getImageProvider(contact.name),
// //                   ),
                  
// //                   title: Container(
// //                     constraints: BoxConstraints(maxWidth: 200), // Adjust the maxWidth as needed
// //                     child: Text(
// //                       contact.name,
// //                       overflow: TextOverflow.ellipsis, // Handles text overflow
// //                     ),
// //                   ),
// //                   // Uncomment and adjust as needed
// //                   // subtitle: Text(contact.lastMessage),
// //                   trailing: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.end,
// //                     children: [
// // SizedBox(width: 10), // Space between the avatar and the text
// //     Text(
// //       "${getRandomDateInCurrentMonth().toLocal()}".split(' ')[0], // Format the date as needed
// //       style: TextStyle(fontSize: 12),
// //     ),

// //                       // Uncomment and adjust as needed
// //                       // Text(contact.time, style: TextStyle(fontSize: 12)),
// //                     ],
// //                   ),
// //                   onTap: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (context) => ChatRoomPage(
// //                           contact: contact,
// //                           chatRoomId: chatRoomId, // Pass chatRoomId
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }



// @override
// Widget build(BuildContext context) {
//   // Reorder the contacts so that "lujain darwazeh" appears first
//   List<Contact> sortedContacts = List.from(widget.contacts);
//   sortedContacts.sort((a, b) {
//     if (a.name.toLowerCase().trim() == "lujain darwazeh") {
//       return -1; // "lujain darwazeh" should appear first
//     } else if (b.name.toLowerCase().trim() == "lujain darwazeh") {
//       return 1;
//     }
//     return 0;
//   });

//   // Generate dates with random gaps up to 12 days between them
//   List<DateTime> dates = _generateRandomDescendingDates(sortedContacts.length);

//   return Scaffold(
//     appBar: AppBar(
//       title: Text('Chats'),
//       backgroundColor: Colors.green,
//       elevation: 0,
//     ),
//     drawer: AppDrawer(),
//     body: Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: 'Search Here...',
//               prefixIcon: Icon(Icons.search),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: sortedContacts.length,
//             itemBuilder: (context, index) {
//               final contact = sortedContacts[index];
//               String currentUserId = FirebaseAuth.instance.currentUser!.uid;
//               String contactId = contact.id;

//               // Generate chatRoomId by combining user and contact IDs
//               List<String> ids = [currentUserId, contactId];
//               ids.sort();
//               String chatRoomId = ids.join("_");

//               return ListTile(
//                 leading: CircleAvatar(
//                   backgroundImage: contact.name.toLowerCase().trim() == "lujain darwazeh"
//                       ? AssetImage('assets/images/lujain.jpg') // Replace with your image path
//                       : _getImageProvider(contact.name),
//                 ),
//                 title: Container(
//                   constraints: BoxConstraints(maxWidth: 200), // Adjust the maxWidth as needed
//                   child: Text(
//                     contact.name,
//                     overflow: TextOverflow.ellipsis, // Handles text overflow
//                   ),
//                 ),
//                 trailing: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     SizedBox(width: 10), // Space between the avatar and the text
//                     Text(
//                       "${dates[index].toLocal()}".split(' ')[0], // Format the date as needed
//                       style: TextStyle(fontSize: 12),
//                     ),
//                   ],
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ChatRoomPage(
//                         contact: contact,
//                         chatRoomId: chatRoomId, // Pass chatRoomId
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }

// // Generate dates with random gaps up to 12 days between them
// List<DateTime> _generateRandomDescendingDates(int count) {
//   DateTime now = DateTime.now();
//   List<DateTime> dates = [now]; // Start with the current date

//   // Generate random dates in descending order
//   for (int i = 1; i < count; i++) {
//     int randomGap = Random().nextInt(12) + 1; // Random gap between 1 and 12 days
//     dates.add(dates.last.subtract(Duration(days: randomGap)));
//   }

//   return dates;
// }

// }
