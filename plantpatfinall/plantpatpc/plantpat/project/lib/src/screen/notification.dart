// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:plantpat/src/screen/login_screen.dart';
// import 'package:plantpat/src/screen/notification_send_msg.dart';
// import 'package:plantpat/src/app.dart';
// import 'package:plantpat/chat/notification_service.dart';

// class FirebaseNotification {
//   static final firebaseMsg = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin flutterLocalNotification =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initNotifications() async {
//     await firebaseMsg.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );
//   }
  

//   static Future getDiveceToken() async {
//     print("helllo");
//     final fcmToken = await firebaseMsg.getToken();
//    print('Token here : ${fcmToken}');
//     bool isUserLog = LoginScreen.isUserLog;
//     if (isUserLog) {
//       await CRUDService.saveUserToken(fcmToken!);
//        print('save token');
//     }
//     firebaseMsg.onTokenRefresh.listen((event) async {
//       if (isUserLog) {
//         await CRUDService.saveUserToken(fcmToken!);
//        print('save token');
//       }
//     });
//   }

//   static Future localNotification() async {
//     const AndroidInitializationSettings initSettingAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     final DarwinInitializationSettings drawInitSetting =
//         DarwinInitializationSettings(
//       onDidReceiveLocalNotification: (id, title, body, payload) => null,
//     );
//     final LinuxInitializationSettings linuxInitSetting =
//         LinuxInitializationSettings(defaultActionName: 'Open notifications');

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initSettingAndroid,
//       iOS: drawInitSetting,
//       linux: linuxInitSetting,
//     );
//     flutterLocalNotification
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()!
//         .requestNotificationsPermission();
//     flutterLocalNotification.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: onNotificationTap,
//         onDidReceiveBackgroundNotificationResponse: onNotificationTap);
//   }

//   static void onNotificationTap(NotificationResponse response) {
//     print('title: $title');
//     if (title == 'Private Reminder') {
//       // CartState().resetCart();
//       navigatorKey.currentState!.pushNamed('cartShop');
//     } else if (title == 'New Collection') {
//       //  CartState().resetCart();
//       // NotificationState.resetNotification();
//       navigatorKey.currentState!.pushNamed('notification');
//       // need to update to what page of new collection or open details of product
//     } else if (title == 'Rating Products') {
//       //  CartState().resetCart();
//       // NotificationState.resetNotification();
//       navigatorKey.currentState!.pushNamed('notification');
//     } else if (title == 'Order Track') {
//      // CartState().resetCart();
//       //NotificationState.resetNotification();
//       navigatorKey.currentState!.pushNamed('TrackOrder');
//     }

//     else {
//       //  NotificationState.resetNotification();
//       navigatorKey.currentState!.pushNamed('notification');
//     }
//   }

//   static Future showNotification(
//     String title,
//     String body,
//     String payload,
//   ) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('channelID', 'channelName',
//             channelDescription: 'channel description',
//             importance: Importance.max,
//             priority: Priority.high,
//             ticker: 'ticker');
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );
//     await flutterLocalNotification.show(0, title, body, notificationDetails,
//         payload: payload);
//   }
// }



import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plantpat/src/screen/login_screen.dart';
import 'package:plantpat/src/screen/notification_send_msg.dart';
import 'package:plantpat/src/app.dart';
import 'package:plantpat/chat/notification_service.dart';

class FirebaseNotification {
  static final firebaseMsg = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotification =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    await firebaseMsg.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
  }

  static Future<void> getDeviceToken() async {
    print("hello");
    final fcmToken = await firebaseMsg.getToken();
    print('Token here: $fcmToken');
    bool isUserLog = LoginScreen.isUserLog;
    if (isUserLog && fcmToken != null) {
      await CRUDService.saveUserToken(fcmToken);
      print('save token');
    }
    firebaseMsg.onTokenRefresh.listen((event) async {
      if (isUserLog) {
        await CRUDService.saveUserToken(event);
        print('save token');
      }
    });
  }

  static Future<void> localNotification() async {
    const AndroidInitializationSettings initSettingAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings drawInitSetting =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings linuxInitSetting =
        LinuxInitializationSettings(defaultActionName: 'Open notifications');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initSettingAndroid,
      iOS: drawInitSetting,
      linux: linuxInitSetting,
    );

    await flutterLocalNotification.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  static void onNotificationTap(NotificationResponse response) {
    final String? payload = response.payload;
    print('payload: $payload');

  
    if (navigatorKey.currentState != null) {
      if (payload != null) {
        if (payload == 'Private Reminder') {
          navigatorKey.currentState?.pushNamed('cartShop');
        } else if (payload == 'New Collection') {
          navigatorKey.currentState?.pushNamed('notification');
        } else if (payload == 'Rating Products') {
          navigatorKey.currentState?.pushNamed('notification');
        } else if (payload == 'Order Track') {
          navigatorKey.currentState?.pushNamed('TrackOrder');
        } else {
          navigatorKey.currentState?.pushNamed('notification');
        }
      } else {
        navigatorKey.currentState?.pushNamed('notification');
      }
    } else {
   
      print('Navigator not available');
    }
  }

  static Future<void> showNotification(
    String title,
    String body,
    String payload,
  ) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelID', 'channelName',
            channelDescription: 'channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotification.show(0, title, body, notificationDetails,
        payload: payload);
  }
}





