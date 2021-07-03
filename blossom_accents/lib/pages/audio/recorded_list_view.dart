import 'package:audioplayers/audioplayers.dart';
import 'package:blossom_accents/models/RecordClass.dart';
import 'package:flutter/material.dart';

class RecordListView extends StatefulWidget {
  final List<RecordClass> records;
  const RecordListView({
    Key key,
    this.records,
  }) : super(key: key);

  @override
  _RecordListViewState createState() => _RecordListViewState();
}

class _RecordListViewState extends State<RecordListView> {
  int _totalDuration;
  int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  int _selectedIndex = -1;


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.records.length,
      shrinkWrap: true,
      reverse: true,
      itemBuilder: (BuildContext context, int i) {
        return (
          title: Text(widget.records.elementAt(i).explain),
          onExpansionChanged: ((newState) {
            if (newState) {
              setState(() {
                _selectedIndex = i;
              });
            }
          }),
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.all(10),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearProgressIndicator(
                    minHeight: 5,
                    backgroundColor: Colors.black,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    value: _selectedIndex == i ? _completedPercentage : 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: _selectedIndex == i
                            ? _isPlaying
                            ? Icon(Icons.pause)
                            : Icon(Icons.play_arrow)
                            : Icon(Icons.play_arrow),
                        onPressed: () => _onPlay(
                            filePath: widget.records.elementAt(i).filePath, index: i),
                      ),
                      //删除太烦了，以后再说吧
                      // IconButton(icon: Icon(Icons.delete_forever), onPressed: (){
                      //
                      //   toast("删除成功！");
                      // })
                    ],

                  )

                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onPlay({@required String filePath, @required int index}) async {
    AudioPlayer audioPlayer = AudioPlayer();

    if (!_isPlaying) {
      audioPlayer.play(filePath, isLocal: true);
      setState(() {
        _selectedIndex = index;
        _completedPercentage = 0.0;
        _isPlaying = true;
      });

      audioPlayer.onPlayerCompletion.listen((_) {
        setState(() {
          _isPlaying = false;
          _completedPercentage = 0.0;
        });
      });
      audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _totalDuration = duration.inMicroseconds;
        });
      });

      audioPlayer.onAudioPositionChanged.listen((duration) {
        setState(() {
          _currentDuration = duration.inMicroseconds;
          _completedPercentage =
              _currentDuration.toDouble() / _totalDuration.toDouble();
        });
      });
    }
  }

}