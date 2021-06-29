import 'package:blossom_accents/common/application.dart';
import 'package:blossom_accents/common/shared_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:blossom_accents/common/application.dart';
import 'package:fluro/fluro.dart';

class MenuWidget extends StatelessWidget {
  final Function(String) onItemClick;
  const MenuWidget({Key key, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          //用户头像
          CircleAvatar(
            radius: 65,
            backgroundColor: Colors.black54,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(curUserImg),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          //用户名
          Text(
            curUsername,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: 'BalsamiqSans'),
          ),
          SizedBox(
            height: 20,
          ),
          sliderItem("主页", Icons.home,context),
          // sliderItem("主页", Icons.home, () {router.navigateTo(context, '/index',transition: TransitionType.inFromLeft); }),
          sliderItem('收藏' ,Icons.favorite,context),
          sliderItem('我的', Icons.person,context),
          sliderItem('设置', Icons.settings,context),
          sliderItem('说明',Icons.integration_instructions,context),
          SizedBox(
            height: 10,
          ),

          sliderItem('登出',Icons.arrow_back_ios,context)
          // sliderItem('登出', Icons.arrow_back_ios,(){)
        ],
      ),
    );
  }

  Widget sliderItem(String title, IconData icons,context) => ListTile(
      title: Text(
        title,
        style:
        TextStyle(color: Colors.black, fontFamily: 'BalsamiqSans_Regular'),
      ),
      leading: Icon(icons, color: Colors.black,),
      //返回onTap
      onTap: () {
        if(title!="登出")
          onItemClick(title);
        else{
          sharedDeleteAll().then((value) =>router.navigateTo(context, '/welcome',transition: TransitionType.inFromLeft) );
        }
      }
  );
}