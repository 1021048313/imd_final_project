import 'package:blossom_accents/pages/Login/components/background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'main_widget.dart';
import 'menu_widget.dart';

class Body extends StatelessWidget {
  GlobalKey<SliderMenuContainerState> _key = new GlobalKey<SliderMenuContainerState>();
  String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderMenuContainer(
          appBarColor: Colors.teal,
          key: _key,
          sliderMenuOpenSize: 200,
          isTitleCenter: false,
          title: Text(
            "首页",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          sliderMenu: MenuWidget(
            onItemClick: (title) {
              _key.currentState.closeDrawer();
            },
          ),
          sliderMain: MainWidget()),
    );
  }
}
