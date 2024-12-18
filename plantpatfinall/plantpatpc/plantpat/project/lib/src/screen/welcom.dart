// import 'package:flutter/material.dart';
// import 'package:plantpat/src/screen/login_screen.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Image Display',
//       home: SplashScreen(),
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateToLogin();
//   }

//   _navigateToLogin() async {
//     await Future.delayed(Duration(seconds: 4), () {});
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => Login()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Image.asset('assets/images/PAT.gif'),
//       ),
//     );
//   }
// }



import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plantpat/src/screen/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Image Display',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
   
    await Future.delayed(Duration(seconds: kIsWeb ? 3 : 4), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isWeb = kIsWeb;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: screenSize.width * (isWeb ? 0.5 : 0.8), 
          height: screenSize.height * (isWeb ? 0.5 : 0.8),
          child: Image.asset('assets/images/PAT.gif', fit: BoxFit.cover),
        ),
      ),
    );
  }
}

