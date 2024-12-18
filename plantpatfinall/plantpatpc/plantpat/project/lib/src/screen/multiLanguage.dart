import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plantpat/locale/locale_controller.dart';

class MultiLanguage extends StatelessWidget {
  static bool isArabic = false;
  static bool isEnglish = true;
  @override
  Widget build(BuildContext context) {
    mylocalcontroller controller = Get.find();

    return Scaffold(
       appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        '1'.tr,
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '12'.tr,
                textAlign: TextAlign.center,
               style: GoogleFonts.roboto(
                  
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              LanguageButton(
                label: '3'.tr,
                onPressed: () {
                  controller.changelang("en");
                  isEnglish = true;
                  isArabic = false;
                },
               
              ),
              SizedBox(height: 20),
              LanguageButton(
                label: '2'.tr,
             
                onPressed: () {
                  controller.changelang("ar");
                  isEnglish = false;
                  isArabic = true;
                },
              ),
            
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const LanguageButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Colors.green, 
        elevation: 5,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
