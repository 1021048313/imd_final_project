import 'package:blossom_accents/cloudbase/Tables.dart';
import 'package:blossom_accents/cloudbase/UserTable.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/models/ListClass.dart';
import 'package:flutter/cupertino.dart';

class CollectionTable {
  //新建集合
  Future<void> addCollection(String header, String content, String userId,
      int time) async {
    listCollection.add({
      'header': header,
      'content': content,
      'time': time,
      'userId': userId,
      'favorCount': 0,
      'wordCount': 0
    }).then((value) => null).catchError((err) => print(err));
  }

  //查找目前的集合
  Future<bool> getIndexList() async {
    listItems.clear();
    await listCollection.get().then((value){
      var v = value.data;
      for (var data in v) {
        String header = data['header'];
        String content = data['content'];
        int favorCount = data['favorCount'];
        int wordCount = data['wordCount'];
        String userId=data['userId'];
        listItems.add(
            ListClass(header, content, userId, favorCount, wordCount));
      }
      return true;
    });
  }
}