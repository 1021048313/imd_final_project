import 'package:blossom_accents/pages/index/components/body.dart';
import 'package:flutter/material.dart';




class FavoriteWidget extends StatefulWidget {
  static const routeName = '/favorite';

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}


class _FavoriteWidgetState extends State<FavoriteWidget> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Body(),
      ),
    );
  }

}