import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/models/ListClass.dart';
import 'package:blossom_accents/cloudbase/UserTable.dart';

class UserClass {
  String userName;
  String userId;
  String userImg;
  List<ListClass> userList;
  UserClass(String userId){
    this.userId=userId;
    //根据id找其他的
  }
  
}
