
import 'dart:io';

import 'package:blossom_accents/cloudbase/CollectionTable.dart';
import 'package:blossom_accents/cloudbase/storageMethod.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

class RecorderView extends StatefulWidget {
  final Function onSaved;
  final String tableId;

  const RecorderView({Key key, @required this.onSaved,@required this.tableId}) : super(key: key);
  @override
  _RecorderViewState createState() => _RecorderViewState();
}

enum RecordingState {
  UnSet,
  Set,
  Recording,
  Stopped,
}

class _RecorderViewState extends State<RecorderView> {

  IconData _recordIcon = Icons.mic_none;
  String _recordText = '开始';
  RecordingState _recordingState = RecordingState.UnSet;
  String filePath;


  // Recorder properties
  FlutterAudioRecorder audioRecorder;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _explainEditingController=TextEditingController();

  @override
  void initState() {
    super.initState();
    FlutterAudioRecorder.hasPermissions.then((hasPermision) {
      if (hasPermision) {
        _recordingState = RecordingState.Set;
        _recordIcon = Icons.mic;
        _recordText = '录音';
      }
    });
  }

  @override
  void dispose() {
    _recordingState = RecordingState.UnSet;
    audioRecorder = null;
    super.dispose();
  }


  showInformationDialog(BuildContext context) async {
    return await showDialog(context: context,
        builder: (context){
          // bool isChecked = false;
          return StatefulBuilder(builder: (context,setState){
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _explainEditingController,
                        validator: (value){
                          if (value.isEmpty) return "解释";
                          else if(value.length>8) return "不要超过10个字啊";
                          else return null;
                        },
                        decoration: InputDecoration(hintText: "解释，别超过10个字"),
                      ),
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('创建'),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      Navigator.of(context).pop();
                    }
                  },
                ),
                TextButton(
                  child: Text('取消'),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
        });
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        RaisedButton(
          onPressed: () async {
            await _onRecordButtonPressed();
            setState(() {});

          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Container(
            width: 50,
            height: 50,
            child: Icon(
              _recordIcon,
              size: 30,
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              child: Text(_recordText),
              padding: const EdgeInsets.all(1),
            ))
      ],
    );
  }

  Future<void> _onRecordButtonPressed() async {
    switch (_recordingState) {
      case RecordingState.Set:
        await _recordVoice();
        break;

      case RecordingState.Recording:
        await _stopRecording();

        _recordingState = RecordingState.Stopped;
        _recordIcon = Icons.fiber_manual_record;
        _recordText = '再来一个';
        break;

      case RecordingState.Stopped:
        await _recordVoice();
        break;

      case RecordingState.UnSet:
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('开一下权限呗'),
        ));
        break;
    }
  }

  _initRecorder(String name) async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    //这个是录音的，保存的文件放缓存 /userAudio/tableId/下面，用explain作为文件名。
    filePath = appDirectory.path +
        '/userAudio/' + widget.tableId+"/"+
        // DateTime.now().millisecondsSinceEpoch.toString() +
        name+
        '.aac';
    if (File(filePath).existsSync()) toast("这个词条用过了");
    // else
      audioRecorder =
          FlutterAudioRecorder(filePath, audioFormat: AudioFormat.AAC);


    await audioRecorder.initialized;
  }

  _startRecording() async {
    await audioRecorder.start();
    // await audioRecorder.current(channel: 0);
  }

  _stopRecording() async {
    await audioRecorder.stop();
    // await showInformationDialog(context);
    String explain=filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));
    //上传到云端。
    String audioId=await StorageMethod().audioUpload(filePath,explain);
    //加到collection数据库里头
    CollectionTable().addSingleAudio(widget.tableId, audioId,explain);
    widget.onSaved();

  }

  Future<void> _recordVoice() async {
    if (await FlutterAudioRecorder.hasPermissions) {
      await showInformationDialog(context);
      await _initRecorder(_explainEditingController.text);
      _explainEditingController.clear();

      await _startRecording();
      _recordingState = RecordingState.Recording;
      _recordIcon = Icons.stop;
      _recordText = '正在...';
    }
    //没有权限
    else {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('开个录音权限呗'),
      ));
    }
  }
}