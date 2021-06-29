import 'package:blossom_accents/cloudbase/UserTable.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Login/login_screen.dart';
import 'background.dart';
import 'package:blossom_accents/pages/components/already_have_an_account_acheck.dart';
import 'package:blossom_accents/pages/components/rounded_button.dart';
import 'package:blossom_accents/pages/components/rounded_input_field.dart';
import 'package:blossom_accents/pages/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userEmail,userPwd,userPwd2;
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "注册",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: "邮箱",
              onChanged: (value) {userEmail=value;},
            ),
            RoundedPasswordField(
              onChanged: (value) {userPwd=value;},
            ),
            RoundedPasswordField(
              onChanged: (value) {userPwd2=value;},
            ),
            RoundedButton(
              text: "注册",
              press: () {
                if(mockUsers.containsKey(userEmail))
                  toast("邮箱已注册");
                else if(userPwd!=userPwd2)
                  toast("两次密码不对");
                else{
                  UserTable().addUserWhenRegister(userPwd, userEmail).then((value) {
                    toast("注册成功");
                    router.navigateTo(context, 'index');
                  });
                }

              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
