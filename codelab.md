summary: BlossomAccents开发过程
id: first_codelab
categories:Android
tags: android
status: Published 
authors: milox
Feedback Link: https://github.com/1021048313/imd_final_project

# BlossomAccents开发过程 

<!--1-->

## 设计

Duration: 10

### 功能列举

设计的几个重点模块列举如下：

- 登录/注册
- 主页查看集合列表
- 用名字来搜索集合
- “我的”列举该用户所创建的集合
- 创建者删除和修改集合名
- 修改用户名和头像

### 数据库

#### 配置

cloudbase的数据库，目前先采用按需计费

> 云开发推出了 Flutter SDK，在 iOS、Android 等移动应用平台中集成，可以方便使用云函数、云存储等能力。
>
> cloudbase自带的云数据库支持：基础读写、聚合搜索、数据库事务、实时推送；
>
> 云存储可以支持音频；

#### user

##### 内容

昵称userName、邮箱userEmail、密码userPwd、头像userImg，以及userId

##### 操作 

- 增：用户注册
- 查：查找用户名和密码用于登录、用userId查剩余值
- 改：修改头像和用户名

#### collection

##### 内容

作者UserId、名称header、字典个数wordCount、词典列表audioList，以及集合id

注：这一部分的数据库设计有问题，需要再修改

##### 操作

- 增：用户创建集合
- 删：作者删除集合
- 查：主页显示全部、根据用户找集合、根据标题关键词找集合、根据集合id找到对应的内容
- 改：增加audioList，作者修改集合名字

清楚设计内容之后进入编写，由于起初的设计仍有欠缺，编写代码过程中有若干修改，**本报告中的编写部分不是以实际编写顺序进行的**，如果有部分报告缺漏请告诉我。

<!-- 2  -->

## 创建项目

Duration: 10

### 新建项目

由于cloudbase不支持最新版本flutter的空安全，所以采用最高2.10.0的版本（本项目用的是2.10.0）。开发过程中用到的依赖包也主要是看没有`null safety`的版本。

创建Flutter Application Project，命名为`blossom_accents`，包名为`com.imd.blossomaccents`。

新建完成后测试是否可以运行，我的gradle运行失败，参考这个[stackoverflow上的解决方案](https://stackoverflow.com/questions/62315496/gradle-could-not-initialize-class-org-codehaus-groovy-runtime-invokerhelper)

### 项目结构

进入默认项目文件夹，在lib文件夹下有`main.dart`。本项目的代码经过整理后分入若干个文件夹中，列举如下：

- /cloudbase 云存储和云数据库的登录、操作等
- /common 全局用到的变量以及sharedPreferences
- /models 存放类
- /pages 放页面
- /routers 路由管理
- main.dart主函数

<!--3-->

## cloudbase登录

Duration: 10

*在开发过程中看到的打包工具，有机会试一试[CloudBase 快速开发工具](https://pub.dev/packages/cloudbase)* 

主要参考：[腾讯cloudbase文档](https://cloud.tencent.com/document/product/876/51930)

### 添加依赖

在项目的`pubspec.yaml`，添加到`dependencies`

```yaml
cloudbase_core: ^0.0.9
cloudbase_auth: ^0.0.11
cloudbase_storage: ^0.0.3
cloudbase_database: ^0.0.10
```

其中core、auth用于登录，storage是云存储（放用户头像、放音频），database就是数据库。

添加完之后运行Pub get

### 创建凭证

创建移动应用安全来源的凭证

打开 [安全设置页面](https://console.cloud.tencent.com/tcb/env/safety) 中，在移动应用安全来源里**添加应用**：

![img](https://main.qcloudimg.com/raw/1c088bc3ddb41faad995d2a8c43186e4.png)

> 因为 Flutter 是跨端开发框架, 所以需要为 Android 和 iOS 各申请一个应用凭证。 应用标识应该是 Android 包名 和 iOS Bundle ID

在本项目只要安卓的包名`com.imd.blossom_accents`即可。

### 匿名登陆

在 [环境设置页面](https://console.cloud.tencent.com/tcb/env/login) 中，单击“登录方式”，然后**启用匿名登录**

![img](https://main.qcloudimg.com/raw/0b6a93991575776761137e9558aed3fc.png)

### 登录

在cloudbase文件夹下写登录，并初始化几个表（在另外的文件中声明，后面会详细说）

```dart
//CloudBaseLogin.dart
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'Tables.dart';
class CloudBaseLogin{
  Future<bool> login() async{
    WidgetsFlutterBinding.ensureInitialized();
    // 初始化 CloudBase
    CloudBaseCore core = CloudBaseCore.init({
      // 填写您的云开发 env
      'env': '',
      // 填写您的移动应用安全来源凭证
      // 生成凭证的应用标识必须是 Android 包名或者 iOS BundleID
      'appAccess': {
        // 凭证
        'key': '',
        // 版本
        'version': ''
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
        return true;
      }).catchError((err) {
        // 登录失败
        print(err);
        return false;
      });
    }
    //初始化数据库、存储
    db = CloudBaseDatabase(core);
    userCollection= db.collection('user');
    listCollection=db.collection('list');
    storage = CloudBaseStorage(core);
    return true;
  }
}
```

初始化 CloudBase 时用到的 `appAccess` 参数可以从控制台的安全来源凭证模块中获取。

环境id就是购买的这个环境的id，一般在控制台列举的环境那可以找到。

![img](https://main.qcloudimg.com/raw/434baba046148be1d2a0effc444ec0f8.png)

<!--4-->

## cloudbase使用

Duration: 10

### 变量声明

```dart
//Tables.dart
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
//用户表
Collection userCollection;
//集合表
Collection listCollection;
//单个表
Collection audioCollection;
//存储
CloudBaseStorage storage;
//数据库（后面有用command），所以搞这个
CloudBaseDatabase db;
```

### 数据库

按照对应的表，分成两个文件

#### 集合表

```dart
//CollectionTable.dart
import 'package:blossom_accents/cloudbase/Tables.dart';
import 'package:blossom_accents/cloudbase/UserTable.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/models/ListClass.dart';
import 'package:blossom_accents/models/RecordClass.dart';

class CollectionTable {
  //新建集合
  Future<String> addCollection(String header,  int time) async {
    var a=await listCollection.add({
      'header': header,
      'time': time,
      'userId': curUserId,
      'wordCount': 0,
      'audioList':[]
    });
    return a.id;
  }
  //删除集合
  deleteCollection(String listId) async{
    await listCollection.doc(listId).remove();
  }
  //修改名字
  modifyCollectionName(String listId,String newName) async{
    print(newName);
    print(listId);
    var a=await listCollection.doc(listId).update({
      'header':newName
    });
    print(a);
  }
  //查找目前的集合-home
  Future<List<ListClass>> getIndexList() async {
      List<ListClass> resultListItems = new List<ListClass>();
      var value=await listCollection.orderBy("time", "desc").get();
      var v = value.data;
      for (var data in v) {
        String header = data['header'];
        int wordCount = data['wordCount'];
        String userId = data['userId'];
        String listId=data['_id'];
        String authorName=await UserTable().getUserNameById(userId);
        resultListItems.add(ListClass(header,userId, wordCount, authorName,listId));
      }
      return resultListItems;
  }

  //根据名字找集合
  Future<List<ListClass>> getSearchList(String value) async {
    List<ListClass> resultListItems = new List<ListClass>();
    print(value);
    //只能用正则表达式的模糊查询了
    var datas=await listCollection.where({
      'header':db.regExp('.*'+value+'.*')
    }).get();
    var v = datas.data;
    for (var data in v) {
      String header = data['header'];
      int wordCount = data['wordCount'];
      String userId = data['userId'];
      String listId=data['_id'];
      String authorName=await UserTable().getUserNameById(userId);
      resultListItems.add(ListClass(header,userId, wordCount, authorName,listId));
    }
    return resultListItems;
  }
  //查找我的集合
  Future<List<ListClass>> getMyListById() async{
    List<ListClass> resultListItems=List<ListClass>();
    var value=await listCollection.where({
      'userId':curUserId
    }).get();
    var datas=value.data;
    for(var data in datas) {
      String header = data['header'];
      int wordCount = data['wordCount'];
      String userId = data['userId'];
      String listId=data['_id'];
      String authorName=await UserTable().getUserNameById(userId);
      resultListItems.add(ListClass(header,userId,  wordCount,authorName,listId));
    }
    return resultListItems;
  }
  //向集合中加入fileId
  addSingleAudio(String tableId,String fileId,String explain) async{
    var audio={"fileName":fileId,"explain":explain};
    var _ = db.command;
    await listCollection.doc(tableId).update({
      'audioList':_.push([audio]),
      'wordCount':_.inc(1)
    });
  }
  //得到audio的下载地址
  Future<List<RecordClass>> getCloudAudioList(String tableId) async{
    var v=await listCollection.doc(tableId).get();
    var data=v.data[0];
    List<RecordClass> result=new List<RecordClass>();
      var audio=data['audioList'];
      for(var singleAudio in audio) {
        result.add(RecordClass(singleAudio["fileName"], singleAudio["explain"]));
      }
    return result;
  }
}
```

#### 用户表

```dart
//UserTable.dart
import 'Tables.dart';
import '../common/application.dart';
class UserTable{
  //根据Id找用户
  Future<String> getUserNameById(String userId) async{
    var value=await userCollection.doc(userId).get();
    return value.data[0]['userName'];
  }
  //注册用户，有默认值
  Future<bool> addUserWhenRegister(String userPwd,String userEmail) async {
    await userCollection.add({
      'userPwd': userPwd,
      'userEmail': userEmail,
      'userName':"起个名字呗",
      'userImg':"https://wx3.sinaimg.cn/mw690/008gNS3Fly1grtq4s6vn7j30c20c4tj4.jpg"
    })
        .then((res) {
      return true;
    })
        .catchError((err) {
      print(err);
      return false;
    });
  }
  // mockUsers-用于登录时检验
  Future<void> getLoginInfo() async{
    mockUsers.clear();
    var datas=await userCollection.get();
    for(var data in datas.data)
      mockUsers[data['userEmail']]=data['userPwd'];
  }
  Future<bool> getUserInfo(String userEmail) async{
      print("开始");
      //根据邮箱查找用户
      await userCollection.where({'userEmail':userEmail}).get().then((res) async {
      //只能查到一个用户
      var data=res.data[0];
      if(data['userName']!=null) curUsername=data['userName'];
      if (data['userImg']!=null)
        curUserImg=data['userImg'];
      curUserId=data['_id'];
      return true;
      });
      return null;
  }
  //根据id找我的
  Future<bool> getUserList() async{
    print("开始");
    //根据id查找用户
    await userCollection.doc(curUserId).get().then((res) async {
      //只能查到一个用户
      var data=res.data[0];
      curUserId=data['_id'];
      return true;
    });
  }
  //设置头像
  setUserImg(String imgPath) async{
    await userCollection.doc(curUserId).update({
      'userImg':imgPath
    });
  }
  //修改用户名
  setUserName(String name) async{
    await userCollection.doc(curUserId).update({
      'userName':name
    });
  }
}
```

### 存储

```dart
//storage_method.dart
import 'package:blossom_accents/common/application.dart';
import 'Tables.dart';
class StorageMethod{
    //上传音频
  Future<String> audioUpload(String filePath,String fileName) async {
    var res=await storage.uploadFile(
        cloudPath: 'userAudios/'+fileName+'.aac',
        filePath: filePath,
        onProcess: (int count, int total) {
          // 当前进度
          print(count);
          // 总进度
          print(total);
        }
    );
    return res.data.fileId;
  }
//上传头像
  Future<String> avatarUpload(String imagePath) async{
    var res=await storage.uploadFile(
      cloudPath: 'userImgs/'+curUserId+'.png',
      filePath: imagePath,
      onProcess: (int count, int total) {
        // 当前进度
        print(count);
        // 总进度
        print(total);
      }
    );
    return res.data.fileId;
  }
//下载音频
  audioDownload(String cloudPath,String localPath) async{
    await storage.downloadFile(
        fileId: cloudPath,
        savePath: localPath,
        onProcess: (int count, int total) {
          // 当前进度
          print(count);
          // 总进度
          print(total);
        }
    ).catchError((onError)=>print(onError));
  }
}
```

<!--4-->

## common

Duration: 10

#### 全局变量和操作

```dart
//application.dart
import 'dart:io';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
//登录和注册时用的
Map<String,String>mockUsers={};
//路由
FluroRouter router=new FluroRouter();
//sharedPreferences用的key
const USER_LOGIN="user-login";
const USER_EMAIL="user-email";
//保存登录信息
String curUsername;
String curUserEmail;
String curUserImg;
String curUserId;
//加载时间
Duration get delayTime => Duration(milliseconds: timeDilation.ceil() * 4250);
//toast
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
//检查文件夹存在
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
//颜色
const Color color1 = Color(0xfff1f3f6);
const Color color2 = Color(0xff366471);
const Color color3 = Color(0xff3e6a77);
const Color color4 = Color(0xff6c909b);
const Color color5 = Color(0x4d3754AA);
const Color color6 = Color(0xFF5247BA);
const Color color7 = Color(0xFFF1E6FF);
```

#### SharedPrefences

```dart
//shared_utils.dart
import 'package:blossom_accents/common/application.dart';
import 'package:shared_preferences/shared_preferences.dart';
//加
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
//返回
Future<Object> sharedGetData(String key) async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  return prefs.get(key);
}
//清除当前登录信息（用于退出登录）
Future<void>sharedDeleteAll() async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  prefs.remove(USER_EMAIL);
  prefs.remove(USER_LOGIN);
}
```

<!--5-->

## models

Duration: 3

为了方便传递对象的信息，本项目中写了两个类

```dart
//ListClass.dart
class ListClass {
  String header;
  int wordCount;
  String userId;
  String listId;
  String authorName;
  ListClass(String header,String userId,int wordCount,String userName,String listId){
    this.header=header;
    this.userId=userId;
    this.wordCount=wordCount;
    this.listId=listId;
    this.authorName=userName==null?"还没取名字":userName;
    this.listId=listId;
  }
}
```

```dart
//RecordClass.dart
class RecordClass{
  String filePath;
  String explain;
  RecordClass(String filePath,String explain){
    this.filePath=filePath;
    this.explain=explain;
  }
}
```

<!--6-->

## Pages-登录注册

Duration: 10

### welcome

在pages中新建welcome文件夹。

welcome主要就是页面跳转

#### 主页面

```dart
//welcome_screen.dart
import 'package:flutter/material.dart';
import 'body.dart';
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
```

#### 背景

```dart
//background.dart
import 'package:flutter/material.dart';
class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);
  //自己整了个背景图，就直接放外链得了
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.network(
              'https://wx2.sinaimg.cn/mw690/008gNS3Fly1gs2rpgtm5sj30j50z0b29.jpg',
            width:size.width),
          ),
          child,
        ],
      ),
    );
  }
}
```

#### body

```dart
//body.dart
import 'package:blossom_accents/cloudbase/UserTable.dart';
import 'package:flutter/material.dart';
import 'background.dart';
import 'package:blossom_accents/pages/components/rounded_button.dart';
import 'package:blossom_accents/common/application.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //屏幕尺寸
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "BlossomAccents",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.6),
            RoundedButton(
              text: "登录",
              press: () async {
                await UserTable().getLoginInfo();
                router.navigateTo(context, 'login');
              },
            ),
            RoundedButton(
              text: "注册",
              color: color7,
              textColor: Colors.black,
              press: () {
                router.navigateTo(context, 'register');
              },
            ),
          ],
        ),
      ),
    );
  }
}

```

### login

login需要给sharedPreferences增加内容，以及检验用户是否存在、用户邮箱和密码是否匹配。

#### 主页面

```dart
//login_screen.dart
import 'package:flutter/material.dart';
import 'body.dart';
class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
```

#### 背景

```dart
//background.dart
import 'package:flutter/material.dart';
class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.network(
              "https://wx1.sinaimg.cn/mw690/008gNS3Fly1gs2vgg1tqrj30700860tf.jpg",
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.network(
              "https://wx1.sinaimg.cn/mw690/008gNS3Fly1gs2vgg262vj308s06kjr9.jpg",
              width: size.width * 0.4,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
```

#### body

```dart
//body.dart
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'background.dart';
import 'package:blossom_accents/pages/components/already_have_an_account_acheck.dart';
import 'package:blossom_accents/pages/components/rounded_button.dart';
import 'package:blossom_accents/pages/components/rounded_input_field.dart';
import 'package:blossom_accents/pages/components/rounded_password_field.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/common/shared_util.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  //Login按钮功能
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);
  Future<String> _loginUser(String userEmail,String userPwd) {
    return Future.delayed(loginTime).then((_) async {
      if (!mockUsers.containsKey(userEmail)) {
        return '用户不存在';
      }
      if (mockUsers[userEmail] != userPwd) {
        return '密码不正确';
      }
      curUserEmail=userEmail;
      //给sharedPrefs增加内容
      sharedAddData(USER_LOGIN, bool, true);
      sharedAddData(USER_EMAIL, String, userEmail);
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    String userEmail,userPwd;
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "登录",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.1),
            RoundedInputField(
              hintText: "邮箱",
              onChanged: (value) {userEmail=value;},
            ),
            RoundedPasswordField(
              onChanged: (value) {userPwd=value;},
            ),
            RoundedButton(
              text: "登录",
              press: () {
                _loginUser(userEmail, userPwd).then((value)
                {
                  //登录失败
                  if(value!=null) {
                    toast(value);
                  }
                  //登陆成功
                  else {
                    router.navigateTo(context, 'index');
                  }
                });
                },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                router.navigateTo(context, 'register');
              },
            ),
          ],
        ),
      ),
    );
  }
}

```

### signup

在pages中新建signup文件夹。

signup需要检验两次密码的一致性。

可以拓展的部分：增加邮箱验证

#### 主页面

```dart
//signup_screen.dart
import 'package:flutter/material.dart';
import 'body.dart';
class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

```

#### 背景

```dart
//background.dart
import 'package:flutter/material.dart';
class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      // Here i can use size.width but use double.infinity because both work as a same
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.network(
              "https://wx4.sinaimg.cn/mw690/008gNS3Fly1gs2vgg3my2j308k07u750.jpg",
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.network(
              "https://wx1.sinaimg.cn/mw690/008gNS3Fly1gs2vgg1liaj3046066q2r.jpg",
              width: size.width * 0.25,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

```

#### body

```dart
//body.dart
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      // Here i can use size.width but use double.infinity because both work as a same
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.network(
              "https://wx4.sinaimg.cn/mw690/008gNS3Fly1gs2vgg3my2j308k07u750.jpg",
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.network(
              "https://wx1.sinaimg.cn/mw690/008gNS3Fly1gs2vgg1liaj3046066q2r.jpg",
              width: size.width * 0.25,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

```

### 组件

主要是这三部分用到的公用组件，它们的功能通过文件名就可以清楚

```dart
//already_have_an_account.dart
import 'package:flutter/material.dart';
import 'package:blossom_accents/common/application.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function press;
  const AlreadyHaveAnAccountCheck({
    Key key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "没账号？ " : "有账号？ ",
          style: TextStyle(color: color6),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "注册" : "登录",
            style: TextStyle(
              color: color6,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
```

```dart
//rounded_button.dart
import 'package:flutter/material.dart';
import 'package:blossom_accents/common/application.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const RoundedButton({
    Key key,
    this.text,
    this.press,
    this.color = color6,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color: color,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
```

```dart
//rounded_button.dart
import 'package:flutter/material.dart';
import 'package:blossom_accents/common/application.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const RoundedButton({
    Key key,
    this.text,
    this.press,
    this.color = color6,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color: color,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
```

```dart
//rounded_password_field.dart
import 'package:flutter/material.dart';
import 'text_field_container.dart';
import 'package:blossom_accents/common/application.dart';
class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);
  bool visible=true;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: visible,
        onChanged: onChanged,
        cursorColor: color6,
        decoration: InputDecoration(
          hintText: "密码",
          icon: Icon(
            Icons.lock,
            color: color6,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

```

```dart
//text_field_container.dart
import 'package:flutter/material.dart';
import 'package:blossom_accents/common/application.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const RoundedButton({
    Key key,
    this.text,
    this.press,
    this.color = color6,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color: color,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}

```

<!--7-->

## Pages-主页-整体

Duration: 10

登录/注册成功后，sharedPreferences中的数据得到更新，用户下次进入该应用时，会首先查看是否登录，就不用重复登录了。进入主页面。

主页面由两部分组成：body和drawer。

### 主页面

进入主页面之前需要保证用户信息加载完成

```dart
//index_screen.dart
import 'package:blossom_accents/cloudbase/UserTable.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/common/shared_util.dart';
import 'package:blossom_accents/pages/index/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class IndexScreen extends StatefulWidget {
  static const routeName = '/index';
  @override
  _IndexScreenState createState() => _IndexScreenState();
}
Future<void> initUserAndIndex(){
  return Future.delayed(delayTime).then((_) async {
    if (curUserEmail==null)
      curUserEmail=await sharedGetData(USER_EMAIL);
      await UserTable().getUserInfo(curUserEmail);
    });
}
class _IndexScreenState extends State<IndexScreen> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: initUserAndIndex(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState==ConnectionState.waiting)
          {
            EasyLoading.show(status: 'loading...');
            return Container();
          }
        else
          {
              EasyLoading.dismiss();
              return SafeArea(
                  child: Scaffold(
                    body: Body(),
                  ),
                );
            }
      },
    );
  }
}
```

### body

body是主屏幕（没有侧边栏的部分），在这里根据侧边栏传入的参数调整主屏幕内容

```dart
//body.dart
import 'package:blossom_accents/common/application.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'components/home_widget.dart';
import 'components/instruction_widget.dart';
import 'menu_widget.dart';
import 'components/my_widget.dart';
import 'components/setting_widget.dart';
class Body extends StatefulWidget{
  BodyPage createState()=>BodyPage();
}
class BodyPage extends State<Body> {
  GlobalKey<SliderMenuContainerState> _key = new GlobalKey<SliderMenuContainerState>();
  //标题
  String title="主页";
  //main widget
  Widget body=HomeWidget();
  Widget _buildBody(String title){
    switch (title){
      case "主页":return HomeWidget();
      case "我的":return MyWidget();
      case "设置":return SettingWidget();
      case "说明":return InstructionWidget();
      default:return HomeWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderMenuContainer(
          appBarColor: color2,
          key: _key,
          sliderMenuOpenSize: 200,
          isTitleCenter: false,
          title: Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          sliderMenu: MenuWidget(
            onItemClick: (title) {
              setState(() {
                this.title = title;
                this.body = _buildBody(title);
              });
              _key.currentState.closeDrawer();
              // router.navigateTo(context, "/"+title,transition: TransitionType.inFromLeft);
            },
          ),
          sliderMain: body),
    );
  }
}
```

### menu

这里显示抽屉的排列

```dart
//menu_widget.dart
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/common/shared_util.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
class MenuWidget extends StatelessWidget {
  final Function(String) onItemClick;
  const MenuWidget({Key key, this.onItemClick}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color5,
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          //用户头像
          CircleAvatar(
            radius: 65,
            backgroundColor: Colors.white54,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(curUserImg),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          //用户名
          Text(
            curUsername,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: 'BalsamiqSans'),
          ),
          SizedBox(
            height: 20,
          ),
          sliderItem("主页", Icons.home,context),
          sliderItem('我的', Icons.person,context),
          sliderItem('设置', Icons.settings,context),
          sliderItem('说明',Icons.integration_instructions,context),
          SizedBox(
            height: 10,
          ),
          sliderItem('登出',Icons.arrow_back_ios,context)
          // sliderItem('登出', Icons.arrow_back_ios,(){)
        ],
      ),
    );
  }
  Widget sliderItem(String title, IconData icons,context) => ListTile(
      title: Text(
        title,
        style:
        TextStyle(color: Colors.white, fontFamily: 'BalsamiqSans_Regular'),
      ),
      leading: Icon(icons, color: Colors.white),
      //返回onTap
      onTap: () {
        if(title!="登出")
          onItemClick(title);
        else{
          sharedDeleteAll().then((value) =>router.navigateTo(context, '/welcome',transition: TransitionType.inFromLeft) );
        }
      }
  );
}
```

这样带抽屉的主页的框架搭好了，接下来就是分别实现各个抽屉列的内容

<!--8-->

## Pages-主页-细节

Duration: 10

### home

由搜索框、背景色和cardlist组成，提供的功能是搜索（搜索的具体实现在后面）、用户点击按钮发布list（同时命名）、用户点击一个list可以跳转到详细页面、用户对自己的集合有区分标签。

```dart
//home_widget.dart
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/models/ListClass.dart';
import 'package:blossom_accents/pages/audio/recorder_home_view.dart';
import 'package:blossom_accents/pages/search/search_form.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:blossom_accents/cloudbase/CollectionTable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
class HomeWidget extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  // String valueText,codeDialog;
  List<ListClass> listItems;
  final TextEditingController _headerEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //点击按钮出现的对话框-用来创建集合的
  //集合 增
  showInformationDialog(BuildContext context) async {
    return await showDialog(context: context,
        builder: (context){
          // bool isChecked = false;
          return StatefulBuilder(builder: (context,setState){
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _headerEditingController,
                        validator: (value){
                          if (value.isEmpty) return "至少得有个标题吧";
                          else if(value.length>8) return "不要超过8个字啊";
                          else return null;
                        },
                        decoration: InputDecoration(hintText: "输入标题，不要超过8个字"),
                      ),
                      // TextFormField(
                      //   controller: _contentEditingController,
                      //   maxLines: 10,
                      //   minLines: 5,
                      //   decoration: InputDecoration(hintText: "输入描述"),
                      // ),
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('创建'),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      //向CollectionTableAdd一个空表
                      var now = new DateTime.now();
                      int time=now.microsecondsSinceEpoch;
                      // await CollectionTable().addCollection(_headerEditingController.text, _contentEditingController.text,time);
                      String tableId=await CollectionTable().addCollection(_headerEditingController.text, time);
                        // tableId = value;
                        print("tableID="+tableId);
                        // print("TableId="+(tableId==null?"table=null":tableId));
                        //向UserTable更新集合，以便后面搜索。
                        // await UserTable().updateListById(tableId).then((value) {
                          toast("增加成功");
                          Navigator.of(context).pop();
                          router.navigateTo(context, 'index', transition: TransitionType.fadeIn);
                        // return HomeWidget();
                          // var listItemsUpdate=ListClass(_headerEditingController.text, _contentEditingController.text, curUserId, 0);
                          // setState(() {
                          //   listItems=[...listItems,listItemsUpdate];
                          //   // _results = [..._results, text];
                          // });
                    }
                  },
                ),
                TextButton(
                  child: Text('取消'),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
        });
  }

  //获取list
  Future<List<ListClass>> initHomeList(){
    return Future.delayed(delayTime).then((_) async {
      return CollectionTable().getIndexList();
    });
  }

  @override
  Widget build(BuildContext context) {

    ListTile makeListTile(ListClass lesson) => ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Column(
          children: <Widget>[
            if(lesson.userId==curUserId) Icon(Icons.person_outline)
            else Icon(Icons.autorenew, color: Colors.white),
          ],
        )
      ),
      //标题
      title: Text(
        lesson.header,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child:Row(
                children: <Widget>[
                  Icon(Icons.menu_book),
                  Text("  "+lesson.wordCount.toString(), style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          )
        ],
      ),
      trailing:
      Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () {
        //传入数据，进入具体list页面
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecorderHomeView(lesson: lesson)));
      },
    );

    Card makeCard(ListClass lesson) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: color3),
        child: makeListTile(lesson),
      ),
    );


    //搜索框
    final topAppBar = PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        //搜索框
        child: Material(
            color: Colors.white,
            child: SearchPage(),
        )
      ) ,
    );
    //先从数据库获取数据
    return FutureBuilder<List<ListClass>>(
      future: initHomeList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          listItems=snapshot.data;
          EasyLoading.dismiss();
          return Scaffold(
            backgroundColor: color4,
            appBar: topAppBar,
            body: Container(
              // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: listItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return makeCard(listItems[index]);
                },
              ),
            ),
            floatingActionButton:FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                await showInformationDialog(context);
              },
            ),
          );
        }
        else{
          EasyLoading.show(status: 'loading...');
          return Container();
        }
      },
    );
  }
}

```

### my

页面和home类似，只是查找函数不同。所以只要数据库那边的函数写对了，上面的home运行时也没出bug，这边的代码就可以无脑用。（后续改进应该把这个页面显示功能打包复用）

```dart
//my_widget.dart
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/models/ListClass.dart';
import 'package:blossom_accents/pages/audio/recorder_home_view.dart';
import 'package:flutter/material.dart';
import 'package:blossom_accents/cloudbase/CollectionTable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
class MyWidget extends StatefulWidget {
  static const routeName = '/my';
  @override
  _MyWidgetState createState() => _MyWidgetState();
}
class _MyWidgetState extends State<MyWidget> {
  List<ListClass> listItems;
  //获取list
  Future<Object> initMyList(){
    return Future.delayed(delayTime).then((_) async {
      return CollectionTable().getMyListById();
    });
  }
  @override
  Widget build(BuildContext context) {

    ListTile makeListTile(ListClass lesson) => ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Column(
            children: <Widget>[
              if(lesson.userId==curUserId) Icon(Icons.person_outline)
              else Icon(Icons.autorenew, color: Colors.white),
            ],
          )
      ),
      //标题
      title: Text(
        lesson.header,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      trailing:
      Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecorderHomeView(lesson: lesson)));
      },
    );
    Card makeCard(ListClass lesson) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: color3),
        child: makeListTile(lesson),
      ),
    );
    return FutureBuilder<Object>(
      future: initMyList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          listItems=snapshot.data;
          EasyLoading.dismiss();
          return Scaffold(
            backgroundColor:color4,
            body: Container(
              // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: listItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return makeCard(listItems[index]);
                },
              ),
            ),
          );
        }
        else{
          EasyLoading.show(status: 'loading...');
          return Container();
        }
      },
    );
  }
}
```

### setting

设置页面需要让用户点击修改头像（拍照、从相册获取、上传）和修改用户名

图片上传的代码在后面

```dart
//setting_widget.dart
import 'dart:ui';
import 'package:blossom_accents/cloudbase/UserTable.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:flutter/material.dart';
class SettingWidget extends StatefulWidget {
  static const routeName = '/setting';
  @override
  _SettingWidgetState createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  final TextEditingController _headerEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showInformationDialog(BuildContext context) async {
    return await showDialog(context: context,
        builder: (context){
          return StatefulBuilder(builder: (context,setState){
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _headerEditingController,
                        validator: (value){
                          if (value.isEmpty) return "新的名字";
                          else if(value.length>8) return "不要超过8个字啊";
                          else return null;
                        },
                        decoration: InputDecoration(hintText: "输入昵称"),
                      ),

                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('确定'),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      //修改用户名
                      curUsername=_headerEditingController.text;
                      print(curUsername);
                     await UserTable().setUserName(curUsername);
                     toast("修改成功！");
                     router.navigateTo(context, 'index');
                    }
                  },
                ),
                TextButton(
                  child: Text('取消'),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
        });
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    return Scaffold(
      body: CustomScrollView(reverse: false, shrinkWrap: false, slivers: <
          Widget>[
        new SliverAppBar(
          pinned: false,
          backgroundColor: color4,
          expandedHeight: height,
          iconTheme: new IconThemeData(color: Colors.transparent),
          flexibleSpace: new InkWell(
              child: new Column(

                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                      onTap:(){
                        router.navigateTo(context, 'avatar');
                      },
                      //头像框
                      child: new Container(
                        width:120.0,
                        height: 120.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            image: new DecorationImage(
                                image: new NetworkImage(curUserImg),
                                fit: BoxFit.cover),
                            border: new Border.all(
                                color: Colors.blueGrey, width: 2.0)),
                      )),
                  //用户名
                  InkWell(
                      onTap: () async {await showInformationDialog(context);},
                      child:new Container(
                        margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        child: new Text(
                          curUsername,
                          style: new TextStyle(color: Colors.black, fontSize: 40.0),
                        ),
                      )
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: new Text(
                      ""+curUserEmail,
                      style: new TextStyle(color: Colors.black54, fontSize: 20.0),
                    ),
                  )
                ],
              )),
        ),
      ]),
    );
  }
}
```

### instruction

这个就自我放飞了，随便写了点东西进去

```dart
import 'package:blossom_accents/cloudbase/CollectionTable.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
class InstructionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Trumpet Boy',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );

    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            child: _buildButtonColumn(color, Icons.mail_outlined, '邮箱',),
            onTap: () async {await showButtonDialog("有事找我：milox26@outlook.com",context);},
          ),
          InkWell(
            child: _buildButtonColumn(color, Icons.auto_awesome, '打钱'),
            onTap: () async {await showButtonDialog("避免中间商赚差价， ̶这̶么̶烂̶的̶应̶用̶真̶的̶会̶有̶人̶打̶钱̶吗̶，直接找个地方捐助吧，",context);},
          ),
          InkWell(
            child: _buildButtonColumn(color, Icons.share, '分享'),
            onTap: (){
              toast("等它能上线再说");
              // Share.share('等它能上线再说');
            },
          )
        ],
      ),
    );

    Widget textSection = Container(
      padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 10.0),
      child:Column(
        children: <Widget>[
          Text(
            '写这个应用之前想的就是做个不太一样的东西\n'
                '某天我发了张照片问我妈上面的虫子叫啥名字\n'
                '她回复我说家里叫踢kæ丛，普通话不知道是啥\n'
                '鬼知道这个东西怎么翻译，最后也没追究下去\n'
                '市面上的背单词软件那么多，我也想做个词典\n'
                '只不过没有人要从这里学习，只是大家一起玩\n'
                '把我知道的单词的发音记下，让别人分辨分辨\n'
                '众多方言里不乏好玩的发音，瞎猜也是种乐趣\n'
                '当然我实际写这玩意的时候，内心的想法如下',
            softWrap: true,
            style:TextStyle(
              height: 1.5
            ),
          ),
          Image.network('https://graph.baidu.com/thumb/v4/785854806,2787461138.jpg'),
          Text("虽然应用不怎么样，但还是祝大家玩得开心！XD\n"),
          
        ],
      )
    );

    return MaterialApp(
      title: '随便说点',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          children: [
            Image.network(
              'https://iknow-pic.cdn.bcebos.com/d53f8794a4c27d1e7e7d17f216d5ad6eddc438a8',
              width: 600,
              height: 240,
              fit: BoxFit.cover,
            ),
            titleSection,
            textSection,
            buttonSection,
          ],
        ),
      ),
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
  showButtonDialog(String value, BuildContext context) async {
    return await showDialog(context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Text(value),
              actions: <Widget>[
                FlatButton(
                  child: Text('已阅'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
        });
  }
}
```

这样一来应用基本成型，接下来补充之前提到的各种功能

<!--8-->

## 换头行动

Duration: 10

主要用的是image_picker，有从相机拍照和从相册获取的功能（但是模拟手机不能覆盖全型号，其它型号的手机能不能用我也不清楚。）

获得照片后，会将该照片上传到云端，获得fileId，因为flutter可以直接用url展示图片，所以在数据库中存入该图片的实际链接即可方便地获取头像。

```dart
//avatar_change.dart
import 'dart:io';
import 'package:blossom_accents/cloudbase/Tables.dart';
import 'package:blossom_accents/cloudbase/UserTable.dart';
import 'package:blossom_accents/cloudbase/storageMethod.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/pages/components/rounded_button.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class ImagePickerPage extends StatefulWidget {
  ImagePickerPage({Key key}) : super(key: key);
  _ImagePickerPageState createState() => _ImagePickerPageState();
}
class _ImagePickerPageState extends State<ImagePickerPage> {
  //记录选择的照片
  File _image;
  //拍照
  Future _getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 400);
    setState(() {
      _image = image;
    });
  }
  //相册选择
  Future _getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

//  上传图片到服务器并保存为用户头像
  _uploadImage() async {
    String path=_image.path;
    print("path="+path);
    //获得fileId
    var fileId=await StorageMethod().avatarUpload(path);
    print("fileId="+fileId);
    //把它变成图片存入用户头像里头
    var pictureIds = List<String>();
    pictureIds.add(fileId);
    CloudBaseStorageRes<List<DownloadMetadata>>pictures = await storage
        .getFileDownloadURL((pictureIds));
    curUserImg = pictures.data[0].downloadUrl;
    print(curUserImg);
    await UserTable().setUserImg(curUserImg);
    toast("修改成功！");
    router.navigateTo(context, 'index');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("选择图片并上传"),backgroundColor: color5,),
      body: Container(
        color: color8,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            RoundedButton(
              text: "开启相机",
              press: () async {
                _getImageFromCamera();},
              color: color2,
            ),
            SizedBox(height: 20),
            RoundedButton(
              text: "从相册选",
              press: () async{
                _getImageFromGallery();
              },
              color: color3,
            ),
            SizedBox(height: 30),
            _image == null
                ? Text("啥也没选中")
                : Image.file(
              _image,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            RaisedButton(
              onPressed: (){
                _uploadImage();
              },
              child: Text("确定作为头像？"),
              color: color7,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
```

<!--8-->

## 增加声音

Duration: 10







