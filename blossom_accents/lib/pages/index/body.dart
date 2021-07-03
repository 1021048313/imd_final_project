import 'package:blossom_accents/common/application.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'components/home_widget.dart';
import 'components/instruction_widget.dart';
import 'menu_widget.dart';
import 'components/my_widget.dart';
import 'components/setting_widget.dart';
class Body extends StatefulWidget{
  BodyPage createState()=>BodyPage();
}
class BodyPage extends State<Body> {
  GlobalKey<SliderMenuContainerState> _key = new GlobalKey<SliderMenuContainerState>();
  //标题
  String title="主页";
  //main widget
  Widget body=HomeWidget();
  Widget _buildBody(String title){
    switch (title){
      case "主页":return HomeWidget();
      case "我的":return MyWidget();
      case "设置":return SettingWidget();
      case "说明":return InstructionWidget();
      default:return HomeWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderMenuContainer(
          appBarColor: color2,
          key: _key,
          sliderMenuOpenSize: 200,
          isTitleCenter: false,
          title: Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700,color: Colors.white),
          ),
          sliderMenu: MenuWidget(
            onItemClick: (title) {
              setState(() {
                this.title = title;
                this.body = _buildBody(title);
              });
              _key.currentState.closeDrawer();
              // router.navigateTo(context, "/"+title,transition: TransitionType.inFromLeft);
            },
          ),
          sliderMain: body),
    );
  }
}
