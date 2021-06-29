
import 'package:blossom_accents/cloudbase/Tables.dart';
import 'package:blossom_accents/common/application.dart';

class AudioTable{
  //增加
  Future<String> addAudio(String fileLink,String describe) async {
    audioCollection.add({
      'fileLink': fileLink,
      'describe': describe,
      'userId': curUserId,
    }).then((value){
      return value.id;})
        .catchError((err) => print(err));
  }
}