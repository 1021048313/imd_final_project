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
  }

  //根据id找我的
  Future<bool> getUserList() async{
    print("开始");
    //根据邮箱查找用户
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