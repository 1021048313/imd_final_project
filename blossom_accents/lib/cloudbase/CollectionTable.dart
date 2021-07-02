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
  deleteCollection(String listId) async{
    await listCollection.doc(listId).remove();
  }
  modifyCollectionName(String listId,String newName) async{
    print(newName);
    print(listId);
    var a=await listCollection.doc(listId).update({
      'header':newName
    });
    print(a);
  }

  //查找目前的集合
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
      print("home获取完成");
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

  addSingleAudio(String tableId,String fileId,String explain) async{
    var audio={"fileName":fileId,"explain":explain};
    var _ = db.command;
    await listCollection.doc(tableId).update({
      'audioList':_.push([audio]),
      'wordCount':_.inc(1)
    });
  }
  deleteSingleAudio(String tableId,String fileId) async{

  }

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