import 'package:blossom_accents/cloudbase/UserTable.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/common/shared_util.dart';
import 'package:blossom_accents/pages/index/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class IndexScreen extends StatefulWidget {
  static const routeName = '/index';
  @override
  _IndexScreenState createState() => _IndexScreenState();
}
Future<void> initUserAndIndex(){
  return Future.delayed(delayTime).then((_) async {
    if (curUserEmail==null)
      curUserEmail=await sharedGetData(USER_EMAIL);
      await UserTable().getUserInfo(curUserEmail);
    });
}
class _IndexScreenState extends State<IndexScreen> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: initUserAndIndex(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState==ConnectionState.waiting)
          {
            EasyLoading.show(status: 'loading...');
            return Container();
          }
        else
          {
              EasyLoading.dismiss();
              return SafeArea(
                  child: Scaffold(
                    body: Body(),
                  ),
                );
            }
      },
    );
  }
}