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
      height: size.height,
      width: double.infinity,
      // Here i can use size.width but use double.infinity because both work as a same
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.network(
              "https://wx4.sinaimg.cn/mw690/008gNS3Fly1gs2vgg3my2j308k07u750.jpg",
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.network(
              "https://wx1.sinaimg.cn/mw690/008gNS3Fly1gs2vgg1liaj3046066q2r.jpg",
              width: size.width * 0.25,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
