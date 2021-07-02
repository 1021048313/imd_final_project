import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  //背景图片就是自己整的
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.network(
              'https://wx2.sinaimg.cn/mw690/008gNS3Fly1gs2rpgtm5sj30j50z0b29.jpg',
            width:size.width),
          ),
          child,
        ],
      ),
    );
  }
}
