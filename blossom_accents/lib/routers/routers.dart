import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'routers_handler.dart';

///路由配置
class Routers {
  static String login = "/login";
  static String index = "/index";
  static String welcome="/welcome";
  static String register="/register";
  static String favourite="/favourite";
  static String my="/my";
  static String settings="/settings";
  static String instructions="/instructions";
  static String search="/search";
  static String collect="/collect";
  static String record="/record";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = new Handler(
      // ignore: missing_return
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          print("ROUTE WAS NOT FOUND !!!");
        });

    /// 第一个参数是路由地址，第二个参数是页面跳转和传参，第三个参数是默认的转场动画
    router.define(login, handler: loginHandler);
    router.define(index, handler: indexHandler);
    router.define(welcome, handler: welcomeHandler);
    // router.define(record, handler: recordHandler);
  }
}
