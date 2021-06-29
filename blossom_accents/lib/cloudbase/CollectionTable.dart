import 'package:blossom_accents/cloudbase/Tables.dart';
import 'package:blossom_accents/cloudbase/UserTable.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/models/ListClass.dart';
import 'package:flutter/cupertino.dart';

class CollectionTable {
  //新建集合
  Future<String> addCollection(String header,  int time) async {
    var a=await listCollection.add({
      'header': header,
      // 'content': content,
      'time': time,
      'userId': curUserId,
      'wordCount': 0
    });
    return a.id;
  }

  //查找目前的集合
  Future<List<ListClass>> getIndexList() async {
      List<ListClass> resultListItems = new List<ListClass>();
      // var value=await listCollection.orderBy("time", "asc").get();
      var value=await listCollection.get();
      var v = value.data;

      for (var data in v) {
        String header = data['header'];
        // String content = data['content']==null?"":data['content'];
        // int favorCount = data['favorCount'];
        int wordCount = data['wordCount'];
        String userId = data['userId'];
        String authorName=await UserTable().getUserNameById(userId);
        resultListItems.add(ListClass(header,userId, wordCount, authorName));
      }
        return resultListItems;


  }

  Future<List<ListClass>> getMyListById() async{
    List<ListClass> resultListItems=List<ListClass>();
    await listCollection.where({
      'userId':curUserId
    }).get().then((value) {
      var datas=value.data;
      for(var data in datas) {
        String header = data['header'];
        // String content = data['content'];
        // int favorCount = data['favorCount'];
        int wordCount = data['wordCount'];
        String userId = data['userId'];
        UserTable().getUserNameById(userId).then((value){
          String authorName=value;
            resultListItems.add(ListClass(header,userId,  wordCount,authorName));
        });

      }
    });
    return resultListItems;
  }
}