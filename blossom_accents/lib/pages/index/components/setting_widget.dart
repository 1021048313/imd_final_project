import 'dart:ui';
import 'package:blossom_accents/cloudbase/UserTable.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:flutter/material.dart';
class SettingWidget extends StatefulWidget {
  static const routeName = '/setting';
  @override
  _SettingWidgetState createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  final TextEditingController _headerEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showInformationDialog(BuildContext context) async {
    return await showDialog(context: context,
        builder: (context){
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
                          if (value.isEmpty) return "新的名字";
                          else if(value.length>8) return "不要超过8个字啊";
                          else return null;
                        },
                        decoration: InputDecoration(hintText: "输入昵称"),
                      ),

                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('确定'),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      //修改用户名
                      curUsername=_headerEditingController.text;
                      print(curUsername);
                     await UserTable().setUserName(curUsername);
                     toast("修改成功！");
                     router.navigateTo(context, 'index');
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
    final size = MediaQuery.of(context).size;
    final height = size.height;
    return Scaffold(
      body: CustomScrollView(reverse: false, shrinkWrap: false, slivers: <
          Widget>[
        new SliverAppBar(
          pinned: false,
          backgroundColor: color4,
          expandedHeight: height,
          iconTheme: new IconThemeData(color: Colors.transparent),
          flexibleSpace: new InkWell(
              child: new Column(

                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                      onTap:(){
                        router.navigateTo(context, 'avatar');
                      },
                      //头像框
                      child: new Container(
                        width:120.0,
                        height: 120.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            image: new DecorationImage(
                                image: new NetworkImage(curUserImg),
                                fit: BoxFit.cover),
                            border: new Border.all(
                                color: Colors.blueGrey, width: 2.0)),

                      )),
                  //用户名
                  InkWell(
                      onTap: () async {await showInformationDialog(context);},
                      child:new Container(
                        margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        child: new Text(
                          curUsername,
                          style: new TextStyle(color: Colors.black, fontSize: 40.0),
                        ),
                      )
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: new Text(
                      ""+curUserEmail,
                      style: new TextStyle(color: Colors.black54, fontSize: 20.0),
                    ),
                  )
                ],
              )),
        ),
      ]),
    );
  }
}