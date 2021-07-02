import 'dart:io';
import 'package:blossom_accents/cloudbase/Tables.dart';
import 'package:blossom_accents/cloudbase/UserTable.dart';
import 'package:blossom_accents/cloudbase/storageMethod.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/pages/components/rounded_button.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPage extends StatefulWidget {
  ImagePickerPage({Key key}) : super(key: key);
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  //记录选择的照片
  File _image;
  //拍照
  Future _getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 400);
    setState(() {
      _image = image;
    });
  }

  //相册选择
  Future _getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

//  上传图片到服务器并保存为用户头像
  _uploadImage() async {
    String path=_image.path;
    print("path="+path);
    //获得fileId
    var fileId=await StorageMethod().avatarUpload(path);
    print("fileId="+fileId);
    //把它变成图片存入用户头像里头
    var pictureIds = List<String>();
    pictureIds.add(fileId);
    CloudBaseStorageRes<List<DownloadMetadata>>pictures = await storage
        .getFileDownloadURL((pictureIds));
    curUserImg = pictures.data[0].downloadUrl;
    print(curUserImg);
    await UserTable().setUserImg(curUserImg);
    toast("修改成功！");
    router.navigateTo(context, 'index');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("选择图片并上传"),backgroundColor: color5,),
      body: Container(
        color: color8,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            RoundedButton(
              text: "开启相机",
              press: () async {
                _getImageFromCamera();},
              color: color2,
            ),
            SizedBox(height: 20),
            RoundedButton(
              text: "从相册选",
              press: () async{
                _getImageFromGallery();
              },
              color: color3,
            ),
            SizedBox(height: 30),
            _image == null
                ? Text("啥也没选中")
                : Image.file(
              _image,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            RaisedButton(
              onPressed: (){
                _uploadImage();
              },
              child: Text("确定作为头像？"),
              color: color7,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}