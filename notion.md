# BlossomAccents

## 设计

### 功能

- 经过开屏进入主页面
- 检验登录，没登陆的话登录-注册页面
- 已登录，主页可以看分类内容
- 搜索：按专辑名|用户名|（可以按词条搜吗，这样数据库查起来有点痛苦）
- 侧边栏：有退出，用户头像显示
- 右上角的设置：夜间模式

### 数据库

#### 需求分析

- 用户表

  - 有：昵称、注册邮箱、密码、

  - 增：注册
  - 删：注销账号
  - 查：登录时查找+按用户名搜索

- 用户的歌单表

- 每个歌单内容表


#### 表的设计

##### 用户-user

| 名        | 类型   |
| --------- | ------ |
| userId    | int    |
| userName  | string |
| userEmail | string |
| userPwd   | string |
| userImage | string |
| userLevel | int    |

##### 歌单-list

| 名     | 类型   | 备注           |
| ------ | ------ | -------------- |
| 歌单id | int    | 主键           |
| 用户id | int    | 和用户表相关联 |
| 名称   | string | 不可空         |
| 描述   | string | 可空           |

##### 单个歌曲-audio

| 名         | 类型                       | 备注         |
| ---------- | -------------------------- | ------------ |
| 歌曲id     | int                        | 主键         |
| 所在歌单id | int                        | 和list表关联 |
| 名称       | string                     | 不可空       |
| 内容       | 我不知道怎么存储短音频文件 | 不可控       |

#### cloudbase配置

**云开发推出了 Flutter SDK，在 iOS、Android 等移动应用平台中集成，可以方便使用云函数、云存储等能力。**，所以装Flutter吧。

cloudbase自带的云数据库支持：基础读写、聚合搜索、数据库事务、实时推送；

云存储可以支持音频；

云函数： 环境内自带云函数功能，可以函数的形式运行后端代码，支持SDK的调用或HTTP请求。云函数存储在云端，可以根据函数的使用情况，自动扩缩容；

HTTP 访问服务：云开发为开发者提供的 HTTP 访问服务，可通过 HTTP 访问云开发资源 

## 编写

### 创建

#### 新建项目

创建Flutter Application Project，命名为`blossom_accents`，使用最高2.10.0的flutter版本，使用的依赖包和版本冲突的看一下以前的版本，(血泪教训：尽量stable)

包名为`com.imd.blossomaccents`。

新建完成后测试是否可以运行，我的gradle运行失败，参考这个[解决方案](https://stackoverflow.com/questions/62315496/gradle-could-not-initialize-class-org-codehaus-groovy-runtime-invokerhelper)

保证用默认代码可以运行成功，可以出现计数器例子。

#### 项目结构

lib文件夹下有若干个文件夹

- /common 大家都要用的
  - application.dart 存放静态全局变量/常量
  - shared_uitl.dart 存放sharedPreferences的操作函数。

- /cloudbase 搞云端的
- /routers 路由管理的
- /pages 放页面的
- main.dart 主程序

#### CloudBase

- [ ] https://pub.dev/packages/cloudbase

参考：[腾讯cloudbase文档](https://cloud.tencent.com/document/product/876/51930)

##### 添加依赖

在项目的 `pubspec.yaml` 文件中添加 `dependencies` 。

```yaml
cloudbase_core: ^0.0.9
cloudbase_auth: ^0.0.11
cloudbase_storage: ^0.0.3
cloudbase_database: ^0.0.10
```

然后Pub get，等待依赖下好。

##### 创建凭证

创建移动应用安全来源的凭证

打开 [安全设置页面](https://console.cloud.tencent.com/tcb/env/safety) 中，在移动应用安全来源里**添加应用**：

![img](https://main.qcloudimg.com/raw/1c088bc3ddb41faad995d2a8c43186e4.png)

> 说明：
>
> 因为 Flutter 是跨端开发框架, 所以需要为 Android 和 iOS 各申请一个应用凭证。 应用标识应该是 Android 包名 和 iOS Bundle ID。

在本项目只要安卓的包名`com.imd.blossom_accents`就ok

##### 匿名登陆

在 [环境设置页面](https://console.cloud.tencent.com/tcb/env/login) 中，单击“登录方式”，然后**启用匿名登录**：

![img](https://main.qcloudimg.com/raw/0b6a93991575776761137e9558aed3fc.png)

##### 代码

application.dart中加入，用于保存登陆时用到的用户邮箱和密码。

```dart
Map<String,String>mockUsers={};
```

cloubase文件夹下

1. Tables.dart，保存静态的数据表。

   ```dart
   import 'package:cloudbase_database/cloudbase_database.dart';
   //用户表
   Collection user;
   //集合表
   Collection list;
   //单个表
   Collection audio;
   ```

2. CloudBaseLogin.dart，用于管理者的登录以及数据库的连接配置

   ```dart
   import 'package:cloudbase_core/cloudbase_core.dart';
   import 'package:cloudbase_auth/cloudbase_auth.dart';
   import 'package:cloudbase_database/cloudbase_database.dart';
   import 'package:flutter/cupertino.dart';
   import 'Tables.dart';
   class CloudBaseLogin{
     //用户表
   
     Future<bool> login() async{
       WidgetsFlutterBinding.ensureInitialized();
       // 初始化 CloudBase
       CloudBaseCore core = CloudBaseCore.init({
           // 填写您的云开发 env
           'env': 'your-env-id',
           // 填写您的移动应用安全来源凭证
           // 生成凭证的应用标识必须是 Android 包名或者 iOS BundleID
           'appAccess': {
             // 凭证
             'key': 'your-app-access-key',
             // 版本
             'version': 'your-app-access-version'
           }
       });    // 获取登录状态
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
       user= db.collection('user');
       return true;
   
     }
   }
   ```

3. UserTable.dart，放对user表的操作（增删改查，边写边改的，这个是最终版本）

   ```dart
   import 'package:cloudbase_database/cloudbase_database.dart';
   
   import 'Tables.dart';
   import '../common/application.dart';
   
   class UserTable{
   
     //增加
     Future<bool> add(String userName,String userPwd,String userEmail) async {
       user.add({
         'userName': userName,
         'userPwd': userPwd,
         'userEmial': userEmail
       })
           .then((res) {
         print(res);
         return true;
       })
           .catchError((err) {
         print(err);
         return false;
       });
     }
   
     //打印
     printAll() async{
       user.get().then((res) {
         var data=res.data[0];
         print(data);
         // print(data['userName']);
         // print(data['userPwd']);
       }).catchError((err){print(err);});
     }
   
     //删除-真的会有人注销用户吗
     delete(String userName) async{
       user.where({'userName':userName}).remove()
           .then((res) {
         // var deleted = res.deleted;
         print("删成功");
       })
           .catchError((e) {
         print("删失败");
       });
     }
   
   
   // mockUsers-用于登录时检验
   Future<void> getLoginInfo() async{
       // Map<String,String> userLoginInfo=new Map<String,String>();
       await user.get().then((res) {
         var data = res.data[0];
         print(data);
         // mockUsers.update(data['userEmail'].toString(),(value) =>data['userPwd']);
         mockUsers[data['userEmail']]=data['userPwd'];
       });
     // return userLoginInfo;
   
   }
   }
   ```

   初始化 CloudBase 时用到的 `appAccess` 参数可以从控制台的安全来源凭证模块中获取。
   ![img](https://main.qcloudimg.com/raw/434baba046148be1d2a0effc444ec0f8.png)

#### routers

使用`fluro` 加依赖：`fluro: ^1.7.8`

routers/中新建application.dart

```dart
import 'package:fluro/fluro.dart';
class Application {
  static FluroRouter router=new FluroRouter();
}
```

新建routers_handler.dart

```dart
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
//由于现在没有page，所以先空着。
```

新建routers.dart

```dart
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'routers_handler.dart';

///路由配置
class Routers {
  //先定下这三个需要实现的页面
  static String login = "/login";
  static String splash = "/splash";
  static String home = "/home";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = new Handler(
      // ignore: missing_return
        handlerFunc: (BuildContext?context, Map<String, List<String>> params) {
          print("ROUTE WAS NOT FOUND !!!");
        });
  }
}

```

在Application.dart文件中加入

```dart
import 'package:fluro/fluro.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Application {
  static FluroRouter router=new FluroRouter();
}
```

在main.dart中注册路由

```dart
  //路由注册 start
  final FluroRouter router=FluroRouter();
  Routers.configureRoutes(router);
  Application.router=router;
  //路由注册 end
```

使用：

#### sharedpreferences

依赖：

```yaml
  shared_preferences: ^0.5.4+8
```

application.dart中加入

```dart
static const USER_NAME_KEY = "user-name";
static const USER_PW_KEY = "user-pw";
static const USER_LOGIN="user-login";
```

在common中新建shared_util.dart

```dart
import 'package:shared_preferences/shared_preferences.dart';

sharedAddData(String key,Object dataType,Object data) async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  switch(dataType){
    case bool:
      prefs.setBool(key, data as bool);break;
    case double:
      prefs.setDouble(key, data as double);break;
    case int:
      prefs.setInt(key, data as int);break;
    case String:
      prefs.setString(key, data as String);break;
    case List:
      prefs.setStringList(key, data as List<String>);break;
    default:
      prefs.setString(key, data as String);break;
  }
}

Future<Object> sharedGetData(String key) async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  return prefs.get(key);
}

sharedDeleteData(String key) async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  prefs.remove(key);
}

sharedAlterData(String key,Object dataType,Object value) async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  prefs.remove(key);
  sharedAddData(key,dataType,value);
}
sharedDeleteAll() async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  prefs.clear();
}
```

### 主程序



### 登录

[参考UI](https://github.com/abuanwar072/Welcome-Login-Signup-Page-Flutter)

### 代码





### 注册



### 主页















