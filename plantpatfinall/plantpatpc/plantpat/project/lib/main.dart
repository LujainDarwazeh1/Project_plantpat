

import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:plantpat/src/app.dart';
import 'package:plantpat/src/screen/notification.dart';
import 'package:flutter/foundation.dart'; 

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future firebaseBacjgroundNotification(RemoteMessage msg) async {
  if (msg.notification != null) {
    print('some notification recived in background');
  }
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  if (!kIsWeb) {
    print("Current working directory: ${Directory.current.path}");

    final file = File('.env');
    if (await file.exists()) {
      print('Found .env file');
      final contents = await file.readAsString();
      print('Contents of .env file: $contents');
    } else {
      print('No .env file found');
    }
    
    try {
      await dotenv.load(fileName: ".env");
      print("Successfully loaded .env file.");
    } catch (e) {
      print("Error loading .env file: $e");
    }




    
  }

  if (kIsWeb) {
    print('Running on web');
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBueXs9x2N0wxFZ6BZT2mo_ZPs1wh8oJs4",
        
        projectId: "plantpat-e8321",
        messagingSenderId: "536356407905",
        appId: "1:536356407905:web:09994405c0cb0ea9037820",


      ),
    );
    runApp(MyApp());
  } else {
    Stripe.publishableKey = dotenv.env["STRIPE_PUBLISH_KEY"]!;
    await Stripe.instance.applySettings();
    
    await Firebase.initializeApp(
      options: Platform.isAndroid
          ? const FirebaseOptions(
              apiKey: 'AIzaSyDna5Re2swo5RmpeNuTlAUwC9_tXts2Ys4',
              appId: '1:536356407905:android:a8a431339a45b0c1037820',
              messagingSenderId: '536356407905',
              projectId: 'plantpat-e8321',
            )
          : null,
    );
    runApp(MyApp());
  }

  await FirebaseNotification.initNotifications();
  await FirebaseNotification.localNotification();
  FirebaseMessaging.onBackgroundMessage(firebaseBacjgroundNotification);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
    if (msg.notification != null) {
      print(msg);
      print('background notification tapped');
      navigatorKey.currentState!.pushNamed('notification');
    }
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
    String payloadData = jsonEncode(msg.data);
    print('got msg in foreground');
    if (msg.notification != null) {
      FirebaseNotification.showNotification(
          msg.notification!.title!, msg.notification!.body!, payloadData);
    }
  });
  final RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    print('launched from terminated state');
    Future.delayed(Duration(seconds: 1), () {
      navigatorKey.currentState!
          .pushNamed('notification');
    });
  }

  runApp(MyApp());
}

