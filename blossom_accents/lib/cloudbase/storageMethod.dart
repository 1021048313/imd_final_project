import 'package:blossom_accents/common/application.dart';
import 'Tables.dart';
class StorageMethod{
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