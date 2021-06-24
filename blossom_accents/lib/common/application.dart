import 'package:blossom_accents/models/ListClass.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'shared_util.dart';
Map<String,String>mockUsers={};
FluroRouter router=new FluroRouter();

const USER_LOGIN="user-login";
const USER_EMAIL="user-email";

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);
String curUsername="起个名字";
String curUserEmail;
String curUserImg="https://wx3.sinaimg.cn/mw690/008gNS3Fly1grtq4s6vn7j30c20c4tj4.jpg";
String curUserId;
String curUserInfo;
List<ListClass> listItems=List<ListClass>();


