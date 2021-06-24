import 'package:blossom_accents/common/application.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'Tables.dart';
class CloudBaseLogin{
  //用户表

  Future<bool> login() async{
    WidgetsFlutterBinding.ensureInitialized();
    // 初始化 CloudBase
    CloudBaseCore core = CloudBaseCore.init({
      // 填写您的云开发 env
      'env': 'hello-cloudbase-1gu7n3nx256c8a7e',
      // 填写您的移动应用安全来源凭证
      // 生成凭证的应用标识必须是 Android 包名或者 iOS BundleID
      'appAccess': {
        // 凭证
        'key': '80548de3ae4fe091046523185765b9bf',
        // 版本
        'version': '1'
      }
    });
    // 获取登录状态
    CloudBaseAuth auth = CloudBaseAuth(core);
    CloudBaseAuthState authState = await auth.getAuthState();

    // 唤起匿名登录
    if(authState==null){
      await auth.signInAnonymously().then((success) {
        // 登录成功
        print("登陆成功！！");
        print(success);
        return true;
      }).catchError((err) {
        // 登录失败
        print(err);
        return false;
      });
    }
    CloudBaseDatabase db = CloudBaseDatabase(core);
    userCollection= db.collection('user');
    listCollection=db.collection('list');
    audioCollection=db.collection('audio');
    storage = CloudBaseStorage(core);

    return true;

  }
}