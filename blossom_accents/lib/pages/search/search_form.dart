import 'dart:async';

import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/pages/search/search_result.dart';
import 'package:fbutton/fbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fsearch/fsearch.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FSearchController controller;

  bool searching = false;

  @override
  void initState() {
    controller = FSearchController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildDemo2();
  }


  Widget buildDemo2() {
    return StatefulBuilder(builder: (context, setState) {
      return PageWidget(
        searching: searching,
        done: () => searching = false,
        child: FSearch(
          controller: controller,
          height: 50.0,
          backgroundColor: color1,
          style: TextStyle(fontSize: 20.0, height: 1.0, color: Colors.grey),
          // margin: EdgeInsets.only(left: 12.0, right: 12.0, top: 9.0),
          // padding:
          // EdgeInsets.only(left: 6.0, right: 6.0, top: 3.0, bottom: 3.0),
          prefixes: [
            //搜索
            const SizedBox(width: 6.0),
            Icon(
              Icons.search,
              size: 28,
              color: color2,
            ),
            const SizedBox(width: 3.0)
          ],
          suffixes: [
            //删除
            FButton(
              onPressed: () {
                controller.text = null;
              },
              padding: EdgeInsets.only(left: 6.0, right: 16.0),
              color: Colors.transparent,
              effect: true,
              image: Icon(
                Icons.clear,
                size: 28,
                color: color2,
              ),
            ),
            FButton(
              onPressed: () {
                router.navigateTo(context, 'index');
              },
              padding: EdgeInsets.only(left: 6.0, right: 16.0),
              color: Colors.transparent,
              effect: true,
              image: Icon(
                Icons.arrow_back,
                size: 28,
                color: color2,
              ),
            ),
          ],
          onSearch: (value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchResult(value: value)));
            // setState(() {
            //   searching = true;
            // });
          },
        ),
      );
    });
  }



}

class PageWidget extends StatefulWidget {
  Widget child;
  bool searching;
  VoidCallback done;
  double width;
  double height;

  PageWidget({
    // this.width = 200.0,
    this.height = 60.0,
    this.child,
    this.done,
    this.searching = false,
  });

  @override
  _PageWidgetState createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> {
  Timer hideSearching;

  @override
  Widget build(BuildContext context) {
    hideSearching?.cancel();
    List<Widget> children = [];
    children.add(Positioned(
      child: widget.child,
    ));
    return Container(
      // width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
        boxShadow: [
          BoxShadow(
              color: color5, blurRadius: 6.0, offset: Offset(3, 3)),
        ],
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: children,
      ),
    );
  }
}