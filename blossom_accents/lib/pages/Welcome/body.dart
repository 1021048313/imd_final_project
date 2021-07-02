import 'package:blossom_accents/cloudbase/UserTable.dart';
import 'package:flutter/material.dart';
import 'background.dart';
import 'package:blossom_accents/pages/components/rounded_button.dart';
import 'package:blossom_accents/common/application.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //屏幕尺寸
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "BlossomAccents",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.6),
            RoundedButton(
              text: "登录",
              press: () async {
                await UserTable().getLoginInfo();
                router.navigateTo(context, 'login');
              },
            ),
            RoundedButton(
              text: "注册",
              color: color7,
              textColor: Colors.black,
              press: () {
                router.navigateTo(context, 'register');
              },
            ),
          ],
        ),
      ),
    );
  }
}
