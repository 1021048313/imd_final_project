import 'package:blossom_accents/common/application.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListClass {
  String header;
  // String content;
  // int favorCount;
  int wordCount;
  String userId;
  String listId;
  String authorName;
  // 1. 我的/2. 收藏/ 3. 未收藏
  int listType;

  ListClass(String header,String userId,int wordCount,String userName){
    this.header=header;
    // this.content=content;
    this.userId=userId;
    // this.favorCount=favorCount;
    this.wordCount=wordCount;
    this.listId=listId;
    if(userId==curUserId) listType=1;
    this.authorName=userName;
  }
  void setListType(int target){
    this.listType=target;
  }
}