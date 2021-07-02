import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/models/ListClass.dart';
import 'package:blossom_accents/pages/audio/recorder_home_view.dart';
import 'package:blossom_accents/pages/search/search_form.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:blossom_accents/cloudbase/CollectionTable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
class HomeWidget extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  // String valueText,codeDialog;
  List<ListClass> listItems;
  final TextEditingController _headerEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //点击按钮出现的对话框-用来创建集合的
  //集合 增
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
                        controller: _headerEditingController,
                        validator: (value){
                          if (value.isEmpty) return "至少得有个标题吧";
                          else if(value.length>8) return "不要超过8个字啊";
                          else return null;
                        },
                        decoration: InputDecoration(hintText: "输入标题，不要超过8个字"),
                      ),
                      // TextFormField(
                      //   controller: _contentEditingController,
                      //   maxLines: 10,
                      //   minLines: 5,
                      //   decoration: InputDecoration(hintText: "输入描述"),
                      // ),
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('创建'),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      //向CollectionTableAdd一个空表
                      var now = new DateTime.now();
                      int time=now.microsecondsSinceEpoch;
                      // await CollectionTable().addCollection(_headerEditingController.text, _contentEditingController.text,time);
                      String tableId=await CollectionTable().addCollection(_headerEditingController.text, time);
                        // tableId = value;
                        print("tableID="+tableId);
                        // print("TableId="+(tableId==null?"table=null":tableId));
                        //向UserTable更新集合，以便后面搜索。
                        // await UserTable().updateListById(tableId).then((value) {
                          toast("增加成功");
                          Navigator.of(context).pop();
                          router.navigateTo(context, 'index', transition: TransitionType.fadeIn);
                        // return HomeWidget();
                          // var listItemsUpdate=ListClass(_headerEditingController.text, _contentEditingController.text, curUserId, 0);
                          // setState(() {
                          //   listItems=[...listItems,listItemsUpdate];
                          //   // _results = [..._results, text];
                          // });
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

  //获取list
  Future<List<ListClass>> initHomeList(){
    return Future.delayed(delayTime).then((_) async {
      return CollectionTable().getIndexList();
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
        decoration: BoxDecoration(color: color3),
        child: makeListTile(lesson),
      ),
    );


    //搜索框
    final topAppBar = PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(60),
          color: Colors.white,
        ),
        //搜索框
        child: Material(
            color: Colors.white,
            child: SearchPage(),
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
            floatingActionButton:FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                await showInformationDialog(context);
              },
            ),
          );
        }
        else{
          EasyLoading.show(status: 'loading...');
          return Container();
        }
      },
    );
  }
}
