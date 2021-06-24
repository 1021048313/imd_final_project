import 'package:blossom_accents/cloudbase/UserTable.dart';
import 'package:blossom_accents/pages/index/index_screen.dart';
import 'package:blossom_accents/routers/routers.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'cloudbase/CloudBaseLogin.dart';
import 'common/application.dart';
import 'common/shared_util.dart';
import 'pages/Welcome/welcome_screen.dart';

void main() async{

  //路由注册 start
  final FluroRouter routerReg=FluroRouter();
  Routers.configureRoutes(routerReg);
  router=routerReg;
  //路由注册 end

  CloudBaseLogin().login().then((v){
    //v是登陆成功与否
    if(!v){print("Admin数据库登陆失败");return;}
    // UserTable().add("kageyama","1234","5678");
    //成功获取mockUsers，进入登陆页面。
    UserTable().getLoginInfo().then((value) {
      print(mockUsers.length);
    runApp(MyApp());}
    );


    // {mockUsers=value;  print(mockUsers.length);});
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(context) {
    // sharedDeleteData(USER_LOGIN).then((value) => print("删除成功"));
    // sharedDeleteData(USER_EMAIL);
    // sharedDeleteData(USER_NAME);
    // sharedDeleteData(USER_IMG);
    // sharedDeleteData(USER_LOGIN);
    return FutureBuilder<Object>(future: sharedGetData(USER_LOGIN),
        builder: (context, AsyncSnapshot<Object> snapshot) {
          if (snapshot.hasData){
          // 手机上有登陆记录
            return MaterialApp(
              home: IndexScreen(),
              debugShowCheckedModeBanner: false,
              onGenerateRoute: router.generator,
              builder: EasyLoading.init(),
            );
          }
          //没有，进入welcome页面
          else {
            return MaterialApp(
              home: WelcomeScreen(),
              debugShowCheckedModeBanner: false,
              onGenerateRoute: router.generator,
              builder: EasyLoading.init(),
            );
          }
        }
    );
  }
}