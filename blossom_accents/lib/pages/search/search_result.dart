
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/models/ListClass.dart';
import 'package:blossom_accents/pages/audio/recorder_home_view.dart';
import 'package:blossom_accents/pages/search/search_form.dart';
import 'package:flutter/material.dart';
import 'package:blossom_accents/cloudbase/CollectionTable.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';


class SearchResult extends StatefulWidget {
  final String _value;
  //传入参数是widget._lesson
  const SearchResult({Key key, @required String value})
      : assert(value != null),
        _value = value,
        super(key: key);
  static const routeName = '/search';

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  List<ListClass> listItems;


  //获取list
  Future<List<ListClass>> initHomeList(){
    return Future.delayed(delayTime).then((_) async {
      return CollectionTable().getSearchList(widget._value);
    });
  }

  @override
  Widget build(BuildContext context) {

    ListTile makeListTile(ListClass lesson) => ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Column(
            children: <Widget>[
              if(lesson.userId==curUserId) Icon(Icons.person_outline)
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

      subtitle: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child:Row(
                children: <Widget>[
                  Icon(Icons.menu_book),
                  Text("  "+lesson.wordCount.toString(), style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          )
        ],
      ),
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
        decoration: BoxDecoration(color: color4),
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
          //搜索框
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Material(
              color: Colors.white,
              child: SearchPage(),
            ),
          )
      ) ,
    );

    return FutureBuilder<List<ListClass>>(
      future: initHomeList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          listItems=snapshot.data;
          EasyLoading.dismiss();
          return Scaffold(
            backgroundColor: color4,
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
