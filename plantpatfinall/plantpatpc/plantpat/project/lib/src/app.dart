import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:plantpat/locale/locale.dart';
import 'package:plantpat/locale/locale_controller.dart';
import 'package:plantpat/src/screen/DashboardScreen.dart';
import 'package:plantpat/src/screen/chat_ad.dart';
import 'package:plantpat/src/screen/customer.dart';
import 'package:plantpat/src/screen/login_screen.dart'; 
import 'package:plantpat/src/screen/orderscreen.dart';
import 'package:plantpat/src/screen/prod_ad.dart';
import 'package:plantpat/src/screen/signup.dart';
import 'package:plantpat/src/screen/home.dart';
import 'package:plantpat/src/screen/HomeAdmin.dart';
import 'package:plantpat/src/screen/homedelivery.dart';
import 'package:plantpat/src/screen/HomeDecorating.dart';
import 'package:plantpat/src/screen/screen_state.dart';
import 'package:plantpat/src/screen/welcom.dart';
import 'package:plantpat/src/screen/Notification_Page.dart';
import'package:plantpat/src/screen/noti.dart';
import'package:plantpat/src/screen/order_tracking_page.dart';
import 'package:flutter/foundation.dart';


final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {


  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {




   void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');

      }
    });
    super.initState();
  }
  




  @override
  Widget build(BuildContext context) {
    
     Get.put(mylocalcontroller());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null
          ? SplashScreen()
          : Login.usertypee == 'Admin'
              ? HomeAdmin()
              : Login.usertypee == 'Delivery employee'
                  ? HomeDelivery()
                  : Login.usertypee == 'Decorating employee'
                      ? HomeDecorating()
                      : HomePage(),
                         locale: Get.deviceLocale,
      translations: mylocale(),
      navigatorKey: navigatorKey,
      routes: {
        "signup": (context) => Signup(),
        "login": (context) => Login(),
        "homepagee": (context) => HomePage(),
        "homeadmin": (context) => HomeAdmin(),
        "homedelivery": (context) => HomeDelivery(),
        "homeDecorating": (context) => HomeDecorating(),
        "notification": (context) => NotificationsPage(),
        "TrackOrder": (context) => OrderTrackingPage(),



         '/dashboard': (context) => DashboardScreen(),
      '/orders': (context) => OrderScreen(),
     '/customers': (context) => CustomerScreen(),
    // '/chat': (context) => ChatPage(),
    // '/products': (context) => ProductsScreen(),
      '/settings': (context) => SettingsScreen(),
      '/help': (context) => HelpScreen(),



        
      
      },
    );





    
  }
}

