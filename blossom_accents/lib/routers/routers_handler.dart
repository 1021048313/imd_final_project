import 'package:blossom_accents/pages/Welcome/welcome_screen.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../pages/Login/login_screen.dart';
import '../pages/index/index_screen.dart';
///跳转到收藏
// var searchHandler =  Handler(
//     handlerFunc: (BuildContext context, Map<String, List<String>> params) {
//       return SearchPage();
//     });
///跳转到web详情页
// var webDetailsHandler = Handler(
//     handlerFunc: (BuildContext context, Map<String, List<String>> params){
//       String title =params["title"]?.first;
//       String url =params["url"]?.first;
//       return ArticleDetailPage(title: title,url: url,);
//     }
// );
///跳转到体系的详情页
// var classiFicationHandler = Handler(
//     handlerFunc: (BuildContext context, Map<String, List<Object>> params){
//       String classiFicationJsonString =params["classiFicationJson"]?.first;
//       return ClassiFicationPage(classiFicationJsonString);
//     }
// );
///跳转到常用网站
// var commonWebHandler =  Handler(
//     handlerFunc: (BuildContext context, Map<String, List<String>> params) {
//       return CommonWebPage();
//     });
//登录
var loginHandler =  Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return LoginScreen();
    });
//跳转到主页
var indexHandler =  Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return IndexScreen();});
//跳转到欢迎
var welcomeHandler =  Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return WelcomeScreen();});
