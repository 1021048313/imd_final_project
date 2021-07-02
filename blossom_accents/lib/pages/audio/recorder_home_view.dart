import 'dart:async';
import 'dart:io';
import 'package:blossom_accents/cloudbase/CollectionTable.dart';
import 'package:blossom_accents/cloudbase/Tables.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/models/ListClass.dart';
import 'package:blossom_accents/models/RecordClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'recorded_list_view.dart';
import 'recorder_view.dart';
import 'package:blossom_accents/cloudbase/storageMethod.dart';

class RecorderHomeView extends StatefulWidget {
  final ListClass _lesson;
  //传入参数是widget._lesson
  const RecorderHomeView({Key key, @required ListClass lesson})
      : assert(lesson != null),
        _lesson = lesson,
        super(key: key);

  @override
  _RecorderHomeViewState createState() => _RecorderHomeViewState();
}

class _RecorderHomeViewState extends State<RecorderHomeView> {
  Directory appDirectory;
  Stream<FileSystemEntity> fileStream;
  List<RecordClass> records;
  int wordCount;
  bool isAuthor;

  final TextEditingController _contentEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //删除的弹窗
  showDeleteDialog(BuildContext context) async {
    return await showDialog(context: context,
        builder: (context) {
          // bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("提示"),
              content: Text("确定要删除当前集合吗?"),
              actions: <Widget>[
                FlatButton(
                    child: Text('删除'),
                    onPressed: () async {
                      // Navigator.of(context).pop();
                      await CollectionTable().deleteCollection(
                          widget._lesson.listId);
                      toast("删除成功！");
                      router.navigateTo(context, 'index');
                    }
                ),
                FlatButton(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
        });
  }

  //修改的弹窗
  showModifyDialog(BuildContext context) async {
    return await showDialog(context: context,
        builder: (context) {
          // bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('修改集合名称'),
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _contentEditingController,
                        validator: (value){
                          if (value.isEmpty) return "修改";
                          else if(value.length>8) return "不要超过10个字啊";
                          else return null;
                        },
                        decoration: InputDecoration(hintText: "修改集合名称，不要超过8个字"),
                      ),
                    ],
                  )),
              actions: <Widget>[
                FlatButton(
                    child: Text('确定'),
                    onPressed: () async {
                      await CollectionTable().modifyCollectionName(widget._lesson.listId,_contentEditingController.text);
                      toast("修改成功！");
                      _contentEditingController.clear();
                      router.navigateTo(context, 'index');
                    }
                ),
                FlatButton(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
        });
  }

  //下载文件
  Future<bool> initHomeList() async {
    //先下载到本地
    List<RecordClass> cloudRecordList = new List<RecordClass>();
    cloudRecordList =
    await CollectionTable().getCloudAudioList(widget._lesson.listId);
    //先确保获取到了
    // print(cloudRecordList);


    //然后下载到指定位置，如果已经有了就不用
    Directory directory = await getApplicationDocumentsDirectory();
    String rootSavePath=directory.path+"/userAudio/"+widget._lesson.listId+"/";
    //创建对应的文件夹
    await folderExists(directory.path+"/userAudio");
    await folderExists(directory.path+"/userAudio/"+widget._lesson.listId);
    //下载到本地
    for (var cloudRecord in cloudRecordList){
      String fileId=cloudRecord.filePath;
      String savePath=rootSavePath+cloudRecord.explain+".aac";
      print("savePath="+savePath);
      await StorageMethod().audioDownload(fileId, savePath);
    }
    // print("download ok!");
    return true;

  }

  @override
  void initState() {
    super.initState();
    records = [];
    isAuthor = curUserId == widget._lesson.userId;
    //应用缓存路径
    //从缓存中获得音频文件
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = Directory(value.path+"/userAudio/"+widget._lesson.listId+"/");
      appDirectory.list().listen((onData) {
        //路径是缓存/userAudio/tableId/
        String filePath = onData.path;
        String explain = "";
        if (filePath.endsWith(".aac")) {
          explain = filePath.substring(
              filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));
          records.add(RecordClass(filePath, explain));
        }
      }).onDone(() {
        records = records.reversed.toList();
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    fileStream = null;
    appDirectory = null;
    records = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(isAuthor);
    final authorOperate = isAuthor? new Row(
      children:<Widget>[
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: new BoxDecoration(
              border: isAuthor ? new Border.all(color: Colors.white) : null,
              borderRadius: BorderRadius.circular(10.0)),
          child: new InkWell(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.auto_fix_high, color: Colors.white,),
                        Text(
                          "修改",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onTap: () async {
                      await showModifyDialog(context);
                    }
                ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: new BoxDecoration(
              border: isAuthor ? new Border.all(color: Colors.white) : null,
              borderRadius: BorderRadius.circular(10.0)),
          child:new InkWell(
              child: Row(
                children: <Widget>[
                  Icon(Icons.dangerous, color: Colors.white,),
                  Text(
                    "删除",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              onTap: () async {
                await showDeleteDialog(context);
              }
          ),
        ),
      ]
    ):Container();
    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 40.0),
          Icon(
            isAuthor?Icons.person_outline:Icons.wb_incandescent_outlined,
            color: Colors.white,
            size: 40.0,
          ),
        Container(
          width: 45.0,
          child: new Divider(color: Colors.green),
        ),
        Text(
          widget._lesson.header,
          style: TextStyle(color: Colors.white, fontSize: 45.0),
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Expanded(flex: 1, child: levelIndicator),
            Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      widget._lesson.authorName,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ))),
            Expanded(flex: 3, child: authorOperate)
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery
                .of(context)
                .size
                .height * 0.36,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new NetworkImage(curUserImg),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.36,
          padding: EdgeInsets.all(30.0),
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child:
            Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    _onRecordComplete() {
      records.clear();
      appDirectory.list().listen((onData) async {
        String filePath = onData.path;
        String explain = filePath.substring(
            filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));
        // wordCount++;
        //上传到云端。
        // await StorageMethod().audioUpload(filePath,explain);
        records.add(RecordClass(filePath, explain));
        print("wordCount=" + wordCount.toString());
      }).onDone(() {
        // records.sort();
        records = records.reversed.toList();
        setState(() {});
      });
    }

    return FutureBuilder<bool>(
        future: initHomeList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            EasyLoading.dismiss();
            // print(snapshot.data);
            return Scaffold(
              body: Column(
                children: [
                  Column(
                    children: <Widget>[topContent],
                  ),
                  Expanded(
                    flex: 2,
                    child: RecordListView(
                      records: records,

                    ),
                  ),
                  //判断当前userId是不是作者
                  curUserId != widget._lesson.userId ?
                  Container() :
                  Expanded(
                    flex: 1,
                    child: RecorderView(
                        onSaved: _onRecordComplete,
                        tableId: widget._lesson.listId
                    ),
                  ),
                ],
              ),
            );
          }
          else {
            EasyLoading.show(status: 'loading...');
            return Container();
          }
        }

    );
  }
}
