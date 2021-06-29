import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';

import 'Tables.dart';
import '../common/application.dart';
import '../common/shared_util.dart';

class UserTable{

  // var _=db.command;
  // Future<void> updateListById(String tableId) async {
  //   await userCollection.doc(curUserId).update({
  //     'userList':_.push(tableId)
  //   }).then((value)=>print(value));
  // }

  // Future<String> findOtherById(String userId) async{
  //   await userCollection.where({'_id':userId}).get().then((value){
  //     // print("name="+value.data[0]['userName']);
  //     return value.data[0]['userName'];});
  //
  // }
  //增加
  Future<String> getUserNameById(String userId) async{
    String userName;
    await userCollection.doc(userId).get().then((value){
      userName=value.data[0]['userName'];
    });
    return userName;
  }


  Future<bool> addUserWhenRegister(String userPwd,String userEmail) async {
    await userCollection.add({
      'userPwd': userPwd,
      'userEmail': userEmail,
    })
        .then((res) {
      return true;
    })
        .catchError((err) {
      print(err);
      return false;
    });
  }

  //打印
  printAll() async{
    userCollection.get().then((res) {
      var data=res.data[0];
      // print(data['userName']);
      // print(data['userPwd']);
    }).catchError((err){print(err);});
  }

  //删除-真的会有人注销用户吗
  delete(String userName) async{
    userCollection.where({'userName':userName}).remove()
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
  var datas=await userCollection.get();
  for(var data in datas.data)
    mockUsers[data['userEmail']]=data['userPwd'];
    // await userCollection.get().then((res) {
    //   var datas = res.data;
    //   // mockUsers.update(data['userEmail'].toString(),(value) =>data['userPwd']);
    //   for (var data in datas)
    //     mockUsers[data['userEmail']]=data['userPwd'];
    // });
  // return userLoginInfo;

}


Future<bool> getUserInfo(String userEmail) async{
    print("开始");
  // sharedAddData(USER_PW, String, userPwd);
  //根据邮箱查找用户
    await userCollection.where({'userEmail':userEmail}).get().then((res) async {
    //只能查到一个用户
    var data=res.data[0];
    // sharedAddData(USER_ID, String, data['userId']);
    if(data['userName']!=null) curUsername=data['userName'];
    if(data['userImg']!=null) {
      var pictureIds = List<String>();
      pictureIds.add(data['userImg']);
      CloudBaseStorageRes<List<DownloadMetadata>>pictures = await storage
          .getFileDownloadURL((pictureIds));
      curUserImg = pictures.data[0].downloadUrl;
    }
    curUserId=data['_id'];
    return true;
    });
    return null;
    // sharedAddData(USER_IMG, String, pictures.data[0].downloadUrl);
    // sharedAddData(USER_NAME, String, data['userName']);
    // sharedAddData(USER_PW, String, data['userPwd']);

}

//根据id找我的
  Future<bool> getUserList() async{
    print("开始");
    // sharedAddData(USER_PW, String, userPwd);
    //根据邮箱查找用户
    await userCollection.doc(curUserId).get().then((res) async {
      //只能查到一个用户
      var data=res.data[0];
      // sharedAddData(USER_ID, String, data['userId']);

      curUserId=data['_id'];
      return true;
    });
    // sharedAddData(USER_IMG, String, pictures.data[0].downloadUrl);
    // sharedAddData(USER_NAME, String, data['userName']);
    // sharedAddData(USER_PW, String, data['userPwd']);

  }


}