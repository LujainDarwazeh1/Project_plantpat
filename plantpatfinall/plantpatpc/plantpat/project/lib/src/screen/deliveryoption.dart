import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantpat/src/screen/login_screen.dart';
import 'package:plantpat/src/screen/notification_send_msg.dart';
import 'package:plantpat/src/screen/order_details_user.dart';
import 'package:plantpat/src/screen/payment.dart';
import 'package:plantpat/src/screen/shopping_cart.dart';

class DeliveryOption extends StatefulWidget {
  final double itemPrice; 

  DeliveryOption({required this.itemPrice});

  @override
  _DeliveryOptionState createState() => _DeliveryOptionState();
}

class _DeliveryOptionState extends State<DeliveryOption> {
  String _selectedDeliveryOption = '';
  String? _selectedPaymentMethod='';
  double _deliveryPrice = 0.0;
   List<int> cartIds=[];
    List<int> count=[];

  void _handleRadioValueChange(String? value) {
    if (value != null) {
      setState(() {
        _selectedDeliveryOption = value;
       
        _deliveryPrice = value == 'Free pick up point' ? 0.0 : 20.0;
      });
    }
  }

  void _handlePaymentMethodChange(String? value) {
    if (value != null) {
      setState(() {
        _selectedPaymentMethod = value;
      });
    }
  }

  Future<void> _handleDone() async {

 if (_selectedDeliveryOption == '') {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please select a delivery option.'),
        backgroundColor: Colors.red, 
      ),
    );
    return;







  }

  if (_selectedPaymentMethod == '') {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please select a payment method.'),
        backgroundColor: Colors.red, 
      ),
    );
    return;
  }

 
  if (_selectedPaymentMethod == 'Cash' && _selectedDeliveryOption == 'Free pick up point') {
     print('CartPageState.idddddddd content: ${CartPageState.ids}');
     print('CartPageState.count content: ${CartPageState.countplant}');


      cartIds = CartPageState.ids;
      count=CartPageState.countplant;

 
   Payment.StoreToPay(Login.idd, widget.itemPrice, 'Cash', cartIds, _selectedDeliveryOption,count);


   Payment.updateQuantityOfProduct(cartIds,Login.idd);
   Payment.deleteProductPaidFromShopCart(cartIds,Login.idd);



   print(cartIds);
  
   

showDialog(
  context: context,
  barrierDismissible: false, 
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text(
        'Order Confirmation',
        style: TextStyle(color: Colors.green), 
      ),
      content: Text('Order done. Thank you for your order!'),
      actions: <Widget>[
        TextButton(
        onPressed: () {
  Navigator.of(context).pop();
     Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartPage()),
      );
 
},
child: Text(
  'OK',
  style: TextStyle(color: Colors.green), 
),

        ),
      ],
    );
  },
);




Duration delay = Duration(minutes: 1);
Timer(delay, () async {
  print('Timer triggered after ${delay.inMinutes} minute(s).');
  await triggerNotificationFromPages(
    'Free pick up point',
    "Thank you for your order. Your bill is \$${widget.itemPrice}. Tap on notification to see our Free pick up point ."
  );
  print('Notification triggered.');


});





Duration delay2 = Duration(minutes: 2);
Timer(delay2, ()  {
  print('Timer triggered after ${delay2.inMinutes} minute(s).');
   triggerNotificationFromPages(
    'Rating product',
    "We’d love your feedback. Please rate your experience to help us improve."
  );
  print('Notification triggered.');


});











    return;
  }




double total = widget.itemPrice + _deliveryPrice;



if (_selectedPaymentMethod == 'Cash' && _selectedDeliveryOption == 'Our delivery system') {
    print('CartPageState.idddddddd content: ${CartPageState.ids}');

    cartIds = CartPageState.ids;
     count=CartPageState.countplant;

    
    Payment.StoreToPay(Login.idd, total, 'Cash', cartIds, _selectedDeliveryOption,count);
     Payment.updateQuantityOfProduct(cartIds, Login.idd);
     Payment.deleteProductPaidFromShopCart(cartIds, Login.idd);
    print(cartIds);

showDialog(
  context: context,
  barrierDismissible: false, 
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text(
        'Order Confirmation',
        style: TextStyle(color: Colors.green), 
      ),
      content: Text('Order done. Thank you for your order!'),
      actions: <Widget>[
        TextButton(
       onPressed: () {
  Navigator.of(context).pop(); 
     Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartPage()),
      );
 
},
child: Text(
  'OK',
  style: TextStyle(color: Colors.green), 
),

        ),
      ],
    );
  },
);

    


    Duration delay2 = Duration(minutes: 2);
    Timer(delay2, () async {
      print('Timer triggered after ${delay2.inMinutes} minute(s).');
      await triggerNotificationFromPages(
        'Rating product',
        "We’d love your feedback. Please rate your experience to help us improve."
      );
      print('Notification triggered.');
    });

     print("hellllllllllllllllllllllllllllllllllo");

User? user = FirebaseAuth.instance.currentUser;
   String userId ;
  
  if (user != null) {
     userId = user.uid;
    print("User is authenticated: $userId");
  }
  else{
    userId='';
  }



sendNotificationToServiceEmployee(
  amount: total, 
  payment_method:"Cash",
  userEmail: Login.Email,
  userPhone: Login.phonenumberr,
  firstName: Login.first_name,
  lastName: Login.LastName,
  city: OrderDetailsUserState.cityController.text,
  street: OrderDetailsUserState.streetAddressController.text,
  userid:userId,


);


    return;
  }


    try {
      print('Selected Delivery Option: $_selectedDeliveryOption');

      print('Selected Payment Method: $_selectedPaymentMethod');
      print('Total Price: ${widget.itemPrice + _deliveryPrice}');


 print('Selected payment Option: $_selectedPaymentMethod');

      




if(_selectedPaymentMethod == 'Card'&&_selectedDeliveryOption == 'Our delivery system'){


      Payment.makePayment(context, total);

       print('CartPageState.idddddddd content: ${CartPageState.ids}');

      cartIds = CartPageState.ids;
       count=CartPageState.countplant;

 
  Payment.StoreToPay(Login.idd, total , 'Card', cartIds, _selectedDeliveryOption,count);
   Payment.updateQuantityOfProduct(cartIds,Login.idd);
   Payment.deleteProductPaidFromShopCart(cartIds,Login.idd);
   print(cartIds);



Duration delay = Duration(minutes: 1);
Timer(delay, () async {
  print('Timer triggered after ${delay.inMinutes} minute(s).');
  await triggerNotificationFromPages(
    'Track your order',
    "Thank you for your order. Your bill is \$$total."
  );
  print('Notification triggered.');
});





Duration delay2 = Duration(minutes: 2);
Timer(delay2, () async {
  print('Timer triggered after ${delay2.inMinutes} minute(s).');
  await triggerNotificationFromPages(
    'Rating product',
    "We’d love your feedback. Please rate your experience to help us improve."
  );
  print('Notification triggered.');


});


 print("hellllllllllllllllllllllllllllllllllo");


print('Attempting to send notification to service employee with email: ${Login.Email}');


  User? user = FirebaseAuth.instance.currentUser;
   String userId ;
  
  if (user != null) {
     userId = user.uid;
    print("User is authenticated: $userId");
  }
  else{
    userId='';
  }



sendNotificationToServiceEmployee(
  amount: total, 
  payment_method:"Card",
  userEmail: Login.Email,
  userPhone: Login.phonenumberr,
  firstName: Login.first_name,
  lastName: Login.LastName,
  city: OrderDetailsUserState.cityController.text,
  street: OrderDetailsUserState.streetAddressController.text,
  userid:userId,


);


      

 } 




 if(_selectedPaymentMethod == 'Card'&&_selectedDeliveryOption == 'Free pick up point'){


      Payment.makePayment(context, total);

       print('CartPageState.idddddddd content: ${CartPageState.ids}');

      cartIds = CartPageState.ids;
       count=CartPageState.countplant;


   Payment.StoreToPay(Login.idd, widget.itemPrice , 'Card', cartIds, _selectedDeliveryOption,count);
   Payment.updateQuantityOfProduct(cartIds,Login.idd);
   Payment.deleteProductPaidFromShopCart(cartIds,Login.idd);
   print(cartIds);


Duration delay = Duration(minutes: 1);
Timer(delay, () async {
  print('Timer triggered after ${delay.inMinutes} minute(s).');
  await triggerNotificationFromPages(
    'Free pick up point',
    "Thank you for your order. Your bill is \$${widget.itemPrice}. Our Free pick up point is in Nablus, Rafidia."
  );
  print('Notification triggered.');
});





Duration delay2 = Duration(minutes: 2);
Timer(delay2, () async {
  print('Timer triggered after ${delay2.inMinutes} minute(s).');
  await triggerNotificationFromPages(
    'Rating product',
    "We’d love your feedback. Please rate your experience to help us improve."
  );
  print('Notification triggered.');


});


      

 } 
 
 
 
 

      print('Payment sheet initialized successfully.');
    } catch (e) {
      print('Error initializing payment sheet: $e');
     
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while processing payment.'),
          backgroundColor: Colors.red,
        ),
      );
    }
    
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.itemPrice + _deliveryPrice;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.green, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '98'.tr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 50), 
            ListTile(
              title: Text(
                '99'.tr,
                style: TextStyle(fontSize: 18),
              ),
              leading: Radio<String>(
                value: 'Free pick up point',
                groupValue: _selectedDeliveryOption,
                onChanged: _handleRadioValueChange,
                activeColor: Colors.green, 
              ),
            ),
            ListTile(
              title: Text(
                '100'.tr,
                style: TextStyle(fontSize: 18),
              ),
              leading: Radio<String>(
                value: 'Our delivery system',
                groupValue: _selectedDeliveryOption,
                onChanged: _handleRadioValueChange,
                activeColor: Colors.green, 
              ),
            ),
            SizedBox(height: 50), 
            Text(
              '${'101'.tr} \$${_deliveryPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '${'102'.tr} \$${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 50), 
            Text(
              '103'.tr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20), 
            ListTile(
              title: Text(
                '104'.tr,
                style: TextStyle(fontSize: 18),
              ),
              leading: Radio<String>(
                value: 'Cash',
                groupValue: _selectedPaymentMethod,
                onChanged: _handlePaymentMethodChange,
                activeColor: Colors.green, 
              ),
            ),
            ListTile(
              title: Text(
                '105'.tr,
                style: TextStyle(fontSize: 18),
              ),
              leading: Radio<String>(
                value: 'Card',
                groupValue: _selectedPaymentMethod,
                onChanged: _handlePaymentMethodChange,
                activeColor: Colors.green, 
              ),
            ),
            SizedBox(height: 30), 
            ElevatedButton(
              onPressed: _handleDone,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.green, 
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 8,
              ),
              child: Text(
                '106'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}








//

// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:googleapis/adsense/v2.dart';

// class DeliveryOption extends StatefulWidget {
//   final double itemPrice; // Assuming this is passed from another page

//   DeliveryOption({required this.itemPrice});

//   @override
//   _DeliveryOptionState createState() => _DeliveryOptionState();
// }

// class _DeliveryOptionState extends State<DeliveryOption> {
//   int _selectedOption = 0;
//   double _deliveryPrice = 0.00;
//   late double _totalPrice;
//   int? _selectedPaymentOption; // To track selected payment option







//   @override
//   void initState() {
//     super.initState();
//     _totalPrice = widget.itemPrice;
//   }

//   void _onOptionSelected(int? value) {
//     setState(() {
//       _selectedOption = value ?? 0;
//       _deliveryPrice =
//           (_selectedOption == 0) ? 0.00 : 20.00;
//       _totalPrice = widget.itemPrice + _deliveryPrice;
//     });
//   }

//   void _onPaymentOptionSelected(int? value) {
//     setState(() {
//       _selectedPaymentOption = value;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: const Text(
//           'Select Delivery Option',
//           style: TextStyle(color: Colors.white),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 120),
//            RadioListTile<int>(
//               title: const Text('Free pick up point'),
//               value: 0,
//               groupValue: _selectedOption,
//               onChanged: _onOptionSelected,
//               activeColor: Colors.green, // Radio button color when selected
//             ),
//             RadioListTile<int>(
//               title: const Text('Our delivery system'),
//               value: 1,
//               groupValue: _selectedOption,
//               onChanged: _onOptionSelected,
//               activeColor: Colors.green, // Radio button color when selected
//             ),
//             const SizedBox(height: 50),
//             Center(
//               child: Column(
//                 children: [
//                   Text(
//                     'Delivery Price: \$${_deliveryPrice.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     'Total Price: \$${_totalPrice.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: Column(
//                 children: [
//                   Text(
//                     'Select Payment Option:',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           _onPaymentOptionSelected(0);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: _selectedPaymentOption == 0
//                               ? Colors.green
//                               : Colors.grey,
//                         ),
//                         child: Text(
//                           'Cash',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           _onPaymentOptionSelected(1);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: _selectedPaymentOption == 1
//                               ? Colors.green
//                               : Colors.grey,
//                         ),
//                         child: Text(
//                           'Card',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Handle done button press
//                   if (_selectedPaymentOption == null) {
//                     // Show a message if no payment option is selected
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Please select a payment option')),
//                     );
//                   } 
//                    else if ( _selectedOption== null) {
//                     // Show a message if no payment option is selected
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Please select a  option')),
//                     );
//                   } 

                 

                  
//                   else {
//              ...

//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green, // Background color
//                   padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
//                   textStyle: const TextStyle(fontSize: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12), // Rounded corners
//                   ),
//                 ),
//                 child: Text(
//                   'Done',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }


//     void _handleDone() {
// //aya
//     try {
      

//       double total = widget.itemPrice + _deliveryPrice;
//       //Payment.onPaymentSuccess = widget.onPaymentSuccess;
//       Payment.makePayment(context, total);

//       print('Payment sheet initialized successfully.');
//     } catch (e) {
//       print('Error initializing payment sheet: $e');
//     }
//     //aya
//     // Handle the done action
//     // Example: print or navigate to another page
//   }
// }
