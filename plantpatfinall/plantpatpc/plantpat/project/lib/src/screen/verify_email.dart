import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantpat/src/screen/login_screen.dart';

class VerifyEmail extends StatefulWidget {
  @override
  _VerifyYourEmail createState() => _VerifyYourEmail();
}

class _VerifyYourEmail extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return kIsWeb ? buildWebVerifyEmail() : buildMobileVerifyEmail();
  }

  // Widget buildMobileVerifyEmail() {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Verify Email'),
  //     ),
  //     body: Center(
  //       child: Padding(
  //         padding: const EdgeInsets.all(20.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Text(
  //               'Verify your Email',
  //               style: TextStyle(
  //                 fontSize: 24,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             SizedBox(height: 20),
  //             Text(
  //               'We have sent verification to your email',
  //               textAlign: TextAlign.center,
  //             ),
  //             SizedBox(height: 32),
  //             ElevatedButton(
  //               onPressed: () async {
  //                 // Trigger email verification resend
  //                 if (FirebaseAuth.instance.currentUser != null) {
  //                   await FirebaseAuth.instance.currentUser!
  //                       .sendEmailVerification();
  //                   // Wait for email verification state change
  //                   await FirebaseAuth.instance.currentUser!.reload();
  //                   // Check if email is verified
  //                   if (FirebaseAuth.instance.currentUser!.emailVerified) {
  //                     // Navigate to login screen
  //                     Navigator.pushReplacement(
  //                       context,
  //                       MaterialPageRoute(builder: (context) => Login()),
  //                     );
  //                   } else {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       SnackBar(
  //                         content: Text('Email not yet verified'),
  //                       ),
  //                     );
  //                   }
  //                 } else {
  //                   print('No authenticated user found.');
  //                 }
  //               },
  //               child: Text('Verify Email'),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget buildMobileVerifyEmail() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Stack(
              children: [
               
                Positioned(
                  top: -150.0,
                  left: 70.0,
                  child: Image.asset(
                    'assets/images/email.png',
                    width: 250.0,
                    fit: BoxFit.fitWidth,
                    height: 600.0,
                  ),
                ),
        
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 60.0),
                        Text(
                          'Verify your Email',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'We have sent a verification code to your email.',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () async {
                            
                            if (FirebaseAuth.instance.currentUser != null) {
                              await FirebaseAuth.instance.currentUser!
                                  .sendEmailVerification();
                             
                              await FirebaseAuth.instance.currentUser!.reload();
                          
                              if (FirebaseAuth
                                  .instance.currentUser!.emailVerified) {
                             
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Email not yet verified'),
                                  ),
                                );
                              }
                            } else {
                              print('No authenticated user found.');
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF4B8E4B),
                            ),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(
                                horizontal: 50.0,
                                vertical: 13.0,
                              ),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          child: Text(
                            'Verify Email',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWebVerifyEmail() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: 500,
            height: 600,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      image: AssetImage('images/icon/back.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Verify your Email',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF063A4E),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'We have sent verification to your email',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF063A4E),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                   
                    if (FirebaseAuth.instance.currentUser != null) {
                      await FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                     
                      await FirebaseAuth.instance.currentUser!.reload();
                     
                      if (FirebaseAuth.instance.currentUser!.emailVerified) {
                        
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Email not yet verified'),
                          ),
                        );
                      }
                    } else {
                      print('No authenticated user found.');
                    }
                  },
                  child: Text('Verify Email'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
