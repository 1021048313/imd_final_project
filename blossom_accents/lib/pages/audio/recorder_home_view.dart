import 'dart:async';
import 'dart:io';
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/models/ListClass.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'recorded_list_view.dart';
import 'recorder_view.dart';

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
  List<String> records;

  final TextEditingController _contentEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    records = [];
    //应用缓存路径
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        records.add(onData.path);
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
    
    final coursePrice = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: new Text(
        "个数：" + widget._lesson.wordCount.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 40.0),
        if (widget._lesson.listType==1)
          Icon(
            Icons.person_outline,
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
                      style: TextStyle(color: Colors.white,fontSize:20.0),
                    ))),
            Expanded(flex: 1, child: coursePrice)
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.36,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new NetworkImage(curUserImg),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.36,
          padding: EdgeInsets.all(30.0),
          width: MediaQuery.of(context).size.width,
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

    // final bottomContentText = Text(
    //   widget._lesson.content,
    //   style: TextStyle(fontSize: 15.0),
    // );

    // final bottomContent = Container(
    //   width: MediaQuery.of(context).size.width,
    //   padding: EdgeInsets.all(10.0),
    //   child: Center(
    //     child: Column(
    //       children: <Widget>[bottomContentText],
    //     ),
    //   ),
    // );
    
    
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
          Expanded(
            flex: 1,
            child: RecorderView(
              onSaved: _onRecordComplete,
            ),
          ),
        ],
      ),
    );
  }

  _onRecordComplete() {
    records.clear();
    appDirectory.list().listen((onData) {
      records.add(onData.path);
    }).onDone(() {
      records.sort();
      records = records.reversed.toList();
      setState(() {});
    });
  }
}