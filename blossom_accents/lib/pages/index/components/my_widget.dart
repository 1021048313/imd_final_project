import 'package:blossom_accents/cloudbase/UserTable.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/models/ListClass.dart';
import 'package:blossom_accents/pages/Welcome/welcome_screen.dart';
import 'package:blossom_accents/pages/audio/recorder_home_view.dart';
import 'package:blossom_accents/pages/detaillist/detailpage.dart';
import 'package:blossom_accents/pages/index/index_screen.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:blossom_accents/cloudbase/CollectionTable.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:blossom_accents/common/application.dart';

class MyWidget extends StatefulWidget {
  static const routeName = '/my';

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<ListClass> listItems;


  //获取list
  Future<Object> initMyList(){
    return Future.delayed(delayTime).then((_) async {
      return CollectionTable().getMyListById();
    });

  }

  @override
  Widget build(BuildContext context) {

    ListTile makeListTile(ListClass lesson) => ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Column(
            children: <Widget>[
              if(lesson.listType==1) Icon(Icons.person_outline)
              else Icon(Icons.autorenew, color: Colors.white),
            ],
          )

      ),
      //标题
      title: Text(
        lesson.header,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      // subtitle: Row(
      //   children: <Widget>[
      //     //content
      //     Expanded(
      //         flex: 4,
      //         child: Container(
      //           // tag: 'hero',
      //           child: Padding(
      //               padding: EdgeInsets.only(),
      //               child: Text(lesson.content,
      //                   style: TextStyle(color: Colors.white),
      //                   maxLines: 2,
      //                   overflow: TextOverflow.fade,
      //                   softWrap:true)
      //           ),
      //
      //
      //         )),
      //     //like的个数-不想写回调，不搞了
      //     // Expanded(
      //     //   flex: 1,
      //     //   child: Padding(
      //     //       padding: EdgeInsets.only(left: 10.0),
      //     //       child:Row(
      //     //         children: <Widget>[
      //     //           Icon(Icons.favorite_border),
      //     //           Text(" "+lesson.favorCount.toString(), style: TextStyle(color: Colors.white)),
      //     //         ],
      //     //       ),
      //     //   ),
      //     // ),
      //     //word的个数
      //     Expanded(
      //       flex: 1,
      //       child: Padding(
      //         padding: EdgeInsets.only(left: 10.0),
      //         child:Row(
      //           children: <Widget>[
      //             Icon(Icons.menu_book),
      //             Text(" "+lesson.wordCount.toString(), style: TextStyle(color: Colors.white)),
      //           ],
      //         ),
      //       ),
      //     )
      //   ],
      // ),
      trailing:
      Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecorderHomeView(lesson: lesson)));
        // builder: (context) => null));
      },
    );

    Card makeCard(ListClass lesson) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile(lesson),
      ),
    );


    //搜索框
    final topAppBar = PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Container(
          padding: const EdgeInsets.only(top:10),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(60),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Material(
              color: Colors.white,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.search,color: Colors.grey),
                  Expanded(
                    child: TextField(
                      // textAlign: TextAlign.center,
                      decoration: InputDecoration.collapsed(
                        hintText: '搜索',
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  // InkWell(
                  // )
                ],
              ),
            ),
          )
      ) ,
    );

    return FutureBuilder<Object>(
      future: initMyList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          listItems=snapshot.data;
          EasyLoading.dismiss();
          return Scaffold(
            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
            appBar: topAppBar,
            body: Container(
              // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: listItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return makeCard(listItems[index]);
                },
              ),
            ),
          );
        }
        else{
          EasyLoading.show(status: 'loading...');
          return Container();
        }
        // else return IndexScreen();

      },
    );


  }
}
