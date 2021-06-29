import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'background.dart';
import '../../Signup/signup_screen.dart';
import 'package:blossom_accents/pages/components/already_have_an_account_acheck.dart';
import 'package:blossom_accents/pages/components/rounded_button.dart';
import 'package:blossom_accents/pages/components/rounded_input_field.dart';
import 'package:blossom_accents/pages/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/common/shared_util.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  //Login按钮功能
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);
  Future<String> _loginUser(String userEmail,String userPwd) {
    return Future.delayed(loginTime).then((_) async {
      if (!mockUsers.containsKey(userEmail)) {
        return '用户不存在';
      }
      if (mockUsers[userEmail] != userPwd) {
        return '密码不正确';
      }
      curUserEmail=userEmail;
      //给sharedPrefs增加内容
      sharedAddData(USER_LOGIN, bool, true);
      sharedAddData(USER_EMAIL, String, userEmail);
      // await UserTable().getUserInfo(userEmail).then((value)=>null);
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    String userEmail,userPwd;
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "登录",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            // SvgPicture.asset(
            //   "assets/icons/login.svg",
            //   height: size.height * 0.35,
            // ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "邮箱",
              onChanged: (value) {userEmail=value;},
            ),
            RoundedPasswordField(
              onChanged: (value) {userPwd=value;},
            ),
            RoundedButton(
              text: "登录",
              press: () {
                _loginUser(userEmail, userPwd).then((value)
                {
                  //登录失败
                  if(value!=null) {
                    Fluttertoast.showToast(
                      msg: (value),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.cyan,
                      textColor: Colors.white,
                      fontSize: 16.0
                    );
                  }
                  //登陆成功
                  else {
                    router.navigateTo(context, 'index');
                  }
                });
                },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
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
