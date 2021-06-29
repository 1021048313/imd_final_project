import 'package:blossom_accents/models/ListClass.dart';
import 'package:blossom_accents/pages/detaillist/detailpage.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:blossom_accents/cloudbase/CollectionTable.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:blossom_accents/common/application.dart';

class InstructionWidget extends StatefulWidget {
  @override
  _InstructionWidgetState createState() => _InstructionWidgetState();
}

class _InstructionWidgetState extends State<InstructionWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("91cm的希望"),
      ),
      body:Text("ceshi"),
    );
  }
}
