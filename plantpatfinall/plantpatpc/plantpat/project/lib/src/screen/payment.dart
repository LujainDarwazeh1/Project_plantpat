
import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:plantpat/src/screen/ipaddress.dart';
import 'package:get/get.dart';
import 'package:plantpat/src/app.dart';

import 'package:plantpat/src/screen/login_screen.dart';
import 'package:plantpat/src/screen/notification_send_msg.dart';
import 'package:plantpat/src/screen/shopping_cart.dart';

import 'package:plantpat/src/screen/user_select_location.dart';

import 'dart:typed_data';
import 'package:google_fonts/google_fonts.dart';

class Payment {
  static Map<String, dynamic>? paymentIntent;
  static bool isPay = false;
  static List<int> selectedListToPay = [];
  static List<Map<String, dynamic>> productCart = [];
  //
  static Function()? onPaymentSuccess;

  static void makePayment(BuildContext context, double amount) async {
    print(' in makePayment ');
    print(amount);
    String merchantCountryCode = "IL";
    String currencyCode = "ILS";
 
    print(merchantCountryCode);
    print(currencyCode);
    try {
      paymentIntent = await createPaymentIntent(amount, context, currencyCode);
      var gPay = PaymentSheetGooglePay(
          merchantCountryCode: merchantCountryCode,
          currencyCode: currencyCode,
          testEnv: true);
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!["client_secret"],
        style: ThemeMode.dark,
        merchantDisplayName: "Sabir",
        googlePay: gPay,
      ));
      displayPaymentIntent(context, amount);
    } catch (e) {}
  }

  static void displayPaymentIntent(BuildContext context, double amount) async {
    try {
  print('***********before');
  await Stripe.instance.presentPaymentSheet();
  print('***********after');

  isPay = true;
  print('Done');

 
  final flushbar = Flushbar(
    message: "Payment Done",
    duration: Duration(seconds: 3),
   
    margin: EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
  )..show(context);

  
  await Future.delayed(Duration(seconds: 3));
  
     Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartPage()),
      );

 
  
  if (onPaymentSuccess != null) {
    onPaymentSuccess!();
  }

} catch (e) {
      Flushbar(
        message: "Payment Failed",
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
      ).show(context);
      print('Failed Pay');
    }
   
  }

  static createPaymentIntent(
      double amount, BuildContext context, String currencyCode) async {
    try {
      print(amount);
      print(currencyCode);
      final secretKey = dotenv.env["STRIPE_SECRET_KEY"]!;
      int amountInCents = (amount * 100).toInt();
      Map<String, dynamic> body = {
        "amount": amountInCents.toString(),
        "currency": currencyCode,
      };
      http.Response response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: body,
        headers: {
          "Authorization": "Bearer $secretKey",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var json = jsonDecode(response.body);
        print(json);
        return json;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "CHECKOUT Failed\nSelect Item to CHECKOUT",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ));
        print('error in calling payment intent');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> updateQuantityOfProduct(
      List<int> cart_ids, int user_id) async {
    print(cart_ids);
    final response = await http.put(
      Uri.parse('http://$ip:3000/plantpat/payment/updateTheQuantityToPayment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'cart_ids': cart_ids,
        'user_id': user_id,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('quantity number updated successfully');
    } else {
      print('Failed  to update quantity ');
    }
  }




   static Future<void> StoreToPay(int userId, double amount, String payMethod,
      List<int> cart_ids, String? deliveryOption,List<int> count) async {

    print(amount);
    print(payMethod);
    print(cart_ids);
    print(deliveryOption);
    print(count);

    final response = await http.post(
      Uri.parse('http://$ip:3000/plantpat/payment/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'user_id': userId,
        'amount': amount,
        'payment_method': payMethod,
        'cart_ids':cart_ids,
        'delivery_option': deliveryOption,
        'count':count,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('payment successfully');
    } else {
      print('Failed to pay ');
    }
  }


 static Future<void> deleteProductPaidFromShopCart(
    List<int> cart_ids, int user_id) async {

  final String cartIdsString = cart_ids.join(',');

  
  final String url = 'http://$ip:3000/plantpat/payment/deleteFromCartProductThatPaied?user_id=$user_id&cart_ids=$cartIdsString';

  try {
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Deleted cart item successfully');
    } else {
      print('Failed to delete data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}









    static Future<void> submitRating(List<Map<String, dynamic>> ratings) async {
    print('Ratings: $ratings');

    final response = await http.post(
      Uri.parse('http://$ip:3000/plantpat/plant/addRatingProduct'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': Login.idd,
        'ratings': ratings,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('rating  number added successfully');
    } else {
      print('Failed to add rating number');
    }
  }
}




  Future<void> updateQuantityOfProduct(List<int> cart_ids,int user_id) async {
    print(cart_ids);
    final response = await http.put(
      Uri.parse(
          'http://$ip:3000/plantpat/payment/updateTheQuantityToPayment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'cart_ids': cart_ids,
        'user_id':user_id,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('quantity number updated successfully');
    } else {
      print('Failed  to update quantity ');
    }
  }



//   static Future<void> StoreToPay(int userId, double amount, String payMethod,
//       List<int> cart_ids, String? deliveryOption) async {
//     //
//     print(amount);
//     print(payMethod);
//     print(cart_ids);
//     print(deliveryOption);

//     final response = await http.post(
//       Uri.parse('http://$ip:3000/plantpat/payment/add'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<dynamic, dynamic>{
//         'user_id': userId,
//         'amount': amount,
//         'payment_method': payMethod,
//         'cart_ids':cart_ids,
//         'delivery_option': deliveryOption,
//       }),
//     );

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       print('payment successfully');
//     } else {
//       print('Failed to pay ');
//     }
//   }

//   // delete the product that paied from shopping cart
//   static Future<Map<String, dynamic>?> deleteProductPaidFromShopCart(
//       List<int> cart_ids, int user_id) async {
//     http.Response? response;

//     try {
//       response = await http.delete(Uri.parse(
//           'http://$ip:3000/plantpat/payment/deleteFromCartProductThatPaied?user_id=$user_id&cart_ids?$cart_ids'));
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         print('deleted cart item');
//       } else {
//         print('Failed to fetch data. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print(' Response body:');
//       // throw Exception('Failed to fetch data: $e');
//     }
//     return null;
//   }


//    static Future<void> submitRating(List<Map<String, dynamic>> ratings) async {
//     print('Ratings: $ratings');

//     final response = await http.post(
//       Uri.parse('http://$ip:3000/plantpat/plant/addRatingProduct'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, dynamic>{
//         'userId': Login.idd,
//         'ratings': ratings,
//       }),
//     );

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       print('rating  number added successfully');
//     } else {
//       print('Failed to add rating number');
//     }
//   }