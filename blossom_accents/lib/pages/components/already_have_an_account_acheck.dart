import 'package:flutter/material.dart';
import 'package:blossom_accents/common/application.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function press;
  const AlreadyHaveAnAccountCheck({
    Key key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "没账号？ " : "有账号？ ",
          style: TextStyle(color: color6),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "注册" : "登录",
            style: TextStyle(
              color: color6,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
