import 'dart:io';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
Map<String,String>mockUsers={};
FluroRouter router=new FluroRouter();
const USER_LOGIN="user-login";
const USER_EMAIL="user-email";
String curUsername;
String curUserEmail;
String curUserImg;
String curUserId;
Duration get delayTime => Duration(milliseconds: timeDilation.ceil() * 4250);
void toast(String msg){
  Fluttertoast.showToast(
      msg: (msg),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.cyan,
      textColor: Colors.white,
      fontSize: 16.0
  );
}
folderExists(String filepath) async {
  var file = Directory(filepath);
  try {
    bool exists = await file.exists();
    if (!exists) {
      await file.create();
    }
  } catch (e) {
    print(e);
  }
}

const Color color1 = Color(0xfff1f3f6);
const Color color2 = Color(0xff265b6a);
const Color color3 = Color(0xff437787);
const Color color4 = Color(0xff7296a3);
const Color color5 = Color(0xff0a3352);
const Color color6 = Color(0xFF5247BA);
const Color color7 = Color(0xFFF1E6FF);
const Color color8 = Color(0xc2abe6f5);


