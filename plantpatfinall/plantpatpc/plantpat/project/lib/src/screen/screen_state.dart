

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantpat/src/screen/CoverScreen.dart';
import 'package:plantpat/src/screen/home.dart';
import 'package:plantpat/src/screen/login_screen.dart';

//splash screen
class CoverStateScreen extends StatefulWidget {
  @override
  CoverStateThreeSec createState() => CoverStateThreeSec();
}

class CoverStateThreeSec extends State<CoverStateScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) =>
                    (FirebaseAuth.instance.currentUser == null ||
                            !(FirebaseAuth.instance.currentUser!.emailVerified))
                        ? Login()
                        : HomePage(), 
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: //FirebaseAuth.instance.currentUser == null
              CoverPage()
          //: HomePage(),
          ),
    );
  }
}
