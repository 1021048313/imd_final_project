import 'package:blossom_accents/cloudbase/CollectionTable.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
// Uncomment lines 7 and 10 to view the visual layout at runtime.
// import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

class InstructionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Trumpet Boy',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );

    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            child: _buildButtonColumn(color, Icons.mail_outlined, '邮箱',),
            onTap: () async {await showButtonDialog("有事找我：milox26@outlook.com",context);},
          ),
          InkWell(
            child: _buildButtonColumn(color, Icons.auto_awesome, '打钱'),
            onTap: () async {await showButtonDialog("避免中间商赚差价， ̶这̶么̶烂̶的̶应̶用̶真̶的̶会̶有̶人̶打̶钱̶吗̶，直接找个地方捐助吧，",context);},
          ),
          InkWell(
            child: _buildButtonColumn(color, Icons.share, '分享'),
            onTap: (){
              toast("等它能上线再说");
              // Share.share('等它能上线再说');
            },
          )


        ],
      ),
    );

    Widget textSection = Container(
      padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 10.0),
      child:Column(
        children: <Widget>[
          Text(
            '写这个应用之前想的就是做个不太一样的东西\n'
                '某天我发了张照片问我妈上面的虫子叫啥名字\n'
                '她回复我说家里叫踢kæ丛，普通话不知道是啥\n'
                '鬼知道这个东西怎么翻译，最后也没追究下去\n'
                '市面上的背单词软件那么多，我也想做个词典\n'
                '只不过没有人要从这里学习，只是大家一起玩\n'
                '把我知道的单词的发音记下，让别人分辨分辨\n'
                '众多方言里不乏好玩的发音，瞎猜也是种乐趣\n'
                '当然我实际写这玩意的时候，内心的想法如下',
            softWrap: true,
            style:TextStyle(
              height: 1.5
            ),
          ),
          Image.network('https://graph.baidu.com/thumb/v4/785854806,2787461138.jpg'),
          Text("虽然应用不怎么样，但还是祝大家玩得开心！XD\n"),

        ],
      )
    );

    return MaterialApp(
      title: '随便说点',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          children: [
            Image.network(
              'https://iknow-pic.cdn.bcebos.com/d53f8794a4c27d1e7e7d17f216d5ad6eddc438a8',
              width: 600,
              height: 240,
              fit: BoxFit.cover,
            ),
            titleSection,
            textSection,
            buttonSection,
          ],
        ),
      ),
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  showButtonDialog(String value, BuildContext context) async {
    return await showDialog(context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Text(value),
              actions: <Widget>[
                FlatButton(
                  child: Text('已阅'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
        });
  }
}