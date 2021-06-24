import 'package:blossom_accents/models/ListClass.dart';
import 'package:blossom_accents/pages/detaillist/detailpage.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:blossom_accents/cloudbase/CollectionTable.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:blossom_accents/common/application.dart';

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  String valueText,codeDialog;
  final TextEditingController _headerEditingController = TextEditingController();
  final TextEditingController _contentEditingController=TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //点击按钮出现的对话框-用来创建集合的
  Future<void> showInformationDialog(BuildContext context) async {
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
                          return value.isNotEmpty ? null : "至少得有个标题吧";
                        },
                        decoration: InputDecoration(hintText: "输入标题"),
                      ),
                      TextFormField(
                        controller: _contentEditingController,
                        maxLines: 10,
                        minLines: 5,
                        // validator: (value){
                        //   return value.isNotEmpty ? null : "Invalid Field";
                        // },
                        decoration: InputDecoration(hintText: "输入内容"),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text("Choice Box"),
                      //     Checkbox(value: isChecked, onChanged: (checked){
                      //       setState((){
                      //         isChecked = checked;
                      //       });
                      //     })
                      //   ],
                      // )
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('创建'),
                  onPressed: (){
                    if(_formKey.currentState.validate()){

                      //向CollectionTableAdd一个空表
                      var now = new DateTime.now();
                      int time=now.microsecondsSinceEpoch;
                      CollectionTable().addCollection(
                          _headerEditingController.text, _contentEditingController.text,curUserId,time)
                          .then((value)=>null);
                      Fluttertoast.showToast(
                          msg: ("添加成功！"),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.cyan,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );

                      Navigator.of(context).pop();
                      router.navigateTo(context, 'index',transition:TransitionType.fadeIn );
                    }
                  },
                ),
                TextButton(
                  child: Text('取消'),
                  onPressed: (){
                    Navigator.of(context).pop();
                    // if(_formKey.currentState.validate()){
                    //   // Do something like updating SharedPreferences or User Settings etc.
                    //   Navigator.of(context).pop();
                    // }
                  },
                )
              ],
            );
          });
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

      subtitle: Row(
        children: <Widget>[
          //content
          Expanded(
              flex: 4,
              child: Container(
                // tag: 'hero',
                child: Padding(
                    padding: EdgeInsets.only(),
                    child: Text(lesson.content,
                        style: TextStyle(color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        softWrap:true)
                ),


              )),
          //like的个数
          Expanded(
            flex: 1,
            child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child:Row(
                  children: <Widget>[
                    Icon(Icons.favorite_border),
                    Text(" "+lesson.favorCount.toString(), style: TextStyle(color: Colors.white)),
                  ],
                ),
            ),
          ),
          //word的个数
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child:Row(
                children: <Widget>[
                  Icon(Icons.menu_book),
                  Text(" "+lesson.wordCount.toString(), style: TextStyle(color: Colors.white)),
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
                builder: (context) => DetailPage(lesson: lesson)));
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

    final makeBody = Container(
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: listItems.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(listItems[index]);
        },
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

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: makeBody,
      floatingActionButton:FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          showInformationDialog(context).then((value) => null);
        },
      ),
    );
  }
}
