import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/retry.dart';

import 'package:http/http.dart' as http;
import 'package:plantpat/src/screen/chat.dart';
import 'dart:convert';
import 'package:plantpat/src/screen/ipaddress.dart';
import 'package:plantpat/src/screen/Notification_page.dart';
import 'dart:typed_data';

import 'package:plantpat/src/screen/notification.dart';
import 'package:plantpat/src/screen/notification_send_msg.dart';

import 'package:plantpat/src/screen/settings.dart';


import 'dart:convert';
import 'dart:io';
import'package:plantpat/src/screen/search_page.dart';


class HomeDelivery extends StatefulWidget {
  @override
  _HomeDeliveryState createState() => _HomeDeliveryState();
}

class _HomeDeliveryState extends State<HomeDelivery> {
  int _selectedIndex = 0;








    @override
  void initState() {
  
    super.initState();

    
    FirebaseNotification.getDeviceToken();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      
    });



     switch (index) {
    case 0:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeDelivery()),
      );
      break;
    case 1:  
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatPage()),
      );
      break;


  }
  }



  




Widget _buildHeader() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
      color: Colors.white, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Image.asset('assets/images/deliveryy.png'),
        ],
      ),
    ),
  );
}



  Widget _buildSections() {
    
    backgroundColor: Colors.white;
    return Container(
      padding: EdgeInsets.all(16.0),
     
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 110, 
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Image.asset(
                'assets/images/logo2.png', 
                width: 80, 
                height: 80,
              ),
            ],
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: 40,
            width: 150,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
  child: Container(
    color: Colors.white, 
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        _buildSections(),
        _buildSections(),
        _buildSections(),
        _buildSections(),
         _buildSections(),
          _buildSections(),
           _buildSections(),

      ],
    ),
  ),
),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.green), // Home icon
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.black), // Chat icon
            label: 'Chat',
          ),
        ],
        selectedItemColor: Colors.green,
      ),
    );
  }
  }

