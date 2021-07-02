import 'package:flutter/material.dart';
class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.network(
              "https://wx1.sinaimg.cn/mw690/008gNS3Fly1gs2vgg1tqrj30700860tf.jpg",
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.network(
              "https://wx1.sinaimg.cn/mw690/008gNS3Fly1gs2vgg262vj308s06kjr9.jpg",
              width: size.width * 0.4,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
