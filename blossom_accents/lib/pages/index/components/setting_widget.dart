import 'package:blossom_accents/cloudbase/CollectionTable.dart';
import 'package:blossom_accents/cloudbase/UserTable.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/common/shared_util.dart';
import 'package:blossom_accents/pages/index/components/body.dart';
import 'package:flutter/material.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';



class SettingWidget extends StatefulWidget {
  static const routeName = '/setting';

  @override
  _SettingWidgetState createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置页面"),
      ),
    );
  }
}