import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';


class mylocalcontroller extends GetxController{



  void changelang(String locelang){
    Locale locale = Locale(locelang);

    Get.updateLocale(locale);
  }
}