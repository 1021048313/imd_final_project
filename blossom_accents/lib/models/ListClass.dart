import 'package:blossom_accents/common/application.dart';

class ListClass {
  String header;
  String content;
  int favorCount;
  int wordCount;
  String userId;
  String listId;
  // 1. 我的/2. 收藏/ 3. 未收藏
  int listType;

  ListClass(String header,String content,String userId,int favorCount,int wordCount){
    this.header=header;
    this.content=content;
    this.userId=userId;
    this.favorCount=favorCount;
    this.wordCount=wordCount;
    this.listId=listId;
    if(userId==curUserId) listType=1;
  }
  void setListType(int target){
    this.listType=target;
  }
}