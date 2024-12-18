import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantpat/src/screen/newpass.dart';

class OtpForm extends StatefulWidget {
  final EmailOTP auth;

  const OtpForm({required this.auth});

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final TextEditingController otp1 = TextEditingController();
  final TextEditingController otp2 = TextEditingController();
  final TextEditingController otp3 = TextEditingController();
  final TextEditingController otp4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verification Code ')),
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
                          'Verification Code',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'We have sent verification code to your email.',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.0),
                       
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildOtpTextField(otp1),
                            buildOtpTextField(otp2),
                            buildOtpTextField(otp3),
                            buildOtpTextField(otp4),
                          ],
                        ),
                        SizedBox(height: 20),
                       
                        ElevatedButton(
                          onPressed: () async {
                            String otp =
                                otp1.text + otp2.text + otp3.text + otp4.text;
                            if (await widget.auth.verifyOTP(otp: otp)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Verified")),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewPass()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Invalid Code")),
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF4B8E4B)),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(
                                horizontal: 110.0,
                                vertical: 13.0, 
                              ),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                  color:
                                      const Color.fromARGB(255, 240, 211, 211)
                                          .withOpacity(0.5),
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          child: Text(
                            'Confirm',
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

  Widget buildOtpTextField(TextEditingController controller) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }
}
