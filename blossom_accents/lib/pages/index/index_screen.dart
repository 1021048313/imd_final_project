import 'package:blossom_accents/cloudbase/CollectionTable.dart';
import 'package:blossom_accents/cloudbase/UserTable.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/common/shared_util.dart';
import 'package:blossom_accents/pages/index/components/body.dart';
import 'package:flutter/material.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';



class IndexScreen extends StatefulWidget {
  static const routeName = '/index';

  @override
  _IndexScreenState createState() => _IndexScreenState();
}

Future<bool> initUserAndIndex() async{
  // sharedGetData(USER_NAME).then((value){curUsername=value.toString();print(curUsername);} );
  // sharedGetData(USER_IMG).then((value) =>curUserImg=value.toString() );
  // sharedGetData(USER_ID).then((value) => curUserId=value);
  // sharedGetData(USER_EMAIL).then((value) => curUserEmail=value);
  if (curUserEmail==null) sharedGetData(USER_EMAIL).then((value) => curUserEmail=value.toString());
  print(curUserEmail);
  await UserTable().getUserInfo(curUserEmail).then((value){print("user加载完成");});
  await CollectionTable().getIndexList().then((value){print("Collection加载完成");return true;});
  return null;

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

        // if (snapshot.hasData) {
        //   return WillPopScope(
        //     onWillPop: () => router.navigateTo(context, '/welcome'),
        //     child: SafeArea(
        //       child: Scaffold(
        //         body: Body(),
        //       ),
        //     ),
        //   );
        // }
      },
    );
  }
// final theme = Theme.of(context);
//   return FutureBuilder(future: initUser(), builder: (context, AsyncSnapshot snapshot) {
//     if (snapshot.hasData) {
//           return WillPopScope(
//             onWillPop: () => router.navigateTo(context, '/welcome'),
//             child: SafeArea(
//               child: Scaffold(
//                 // appBar: AppBar(),
//                   body: Body()
//               ),
//             ),
//           );
//         }
//         else {
//           Container();
//         }
//       }
//   );
// }
}