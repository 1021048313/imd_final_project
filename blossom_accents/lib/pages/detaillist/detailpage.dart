// import 'package:blossom_accents/cloudbase/Tables.dart';
// import 'package:blossom_accents/cloudbase/UserTable.dart';
// import 'package:blossom_accents/common/application.dart';
// import 'package:blossom_accents/models/ListClass.dart';
// import 'package:blossom_accents/pages/audio/audio_home.dart';
// import 'package:blossom_accents/pages/audio/recorder_home_view.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class DetailPage extends StatelessWidget {
//   final ListClass lesson;
//   //传入参数是lesson
//   DetailPage({Key key, this.lesson}) : super(key: key);
//   final TextEditingController _headerEditingController = TextEditingController();
//   final TextEditingController _contentEditingController=TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   // Future<String> getAuthorName(String userId) async{
//   //   await UserTable().getUserNameById(userId).then((value) {
//   //     String authorName = value;
//   //     print("createUserName="+authorName);
//   //   });
//   // }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final levelIndicator = Container(
//       child: Container(
//         child: LinearProgressIndicator(
//             backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
//             // value: lesson.favorCount.toDouble(),
//             valueColor: AlwaysStoppedAnimation(Colors.green)),
//       ),
//     );
//
//     final coursePrice = Container(
//       padding: const EdgeInsets.all(7.0),
//       decoration: new BoxDecoration(
//           border: new Border.all(color: Colors.white),
//           borderRadius: BorderRadius.circular(5.0)),
//       child: new Text(
//         "个数：" + lesson.wordCount.toString(),
//         style: TextStyle(color: Colors.white),
//       ),
//     );
//
//     final topContentText = Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         SizedBox(height: 120.0),
//         if (lesson.listType==1)
//           Icon(
//           Icons.person_outline,
//           color: Colors.white,
//           size: 40.0,
//           ),
//         Container(
//           width: 90.0,
//           child: new Divider(color: Colors.green),
//         ),
//         SizedBox(height: 10.0),
//         Text(
//           lesson.header,
//           style: TextStyle(color: Colors.white, fontSize: 45.0),
//         ),
//         SizedBox(height: 30.0),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             // Expanded(flex: 1, child: levelIndicator),
//             Expanded(
//                 flex: 4,
//                 child: Padding(
//                     padding: EdgeInsets.only(left: 10.0),
//                     child: Text(
//                       lesson.authorName,
//                       style: TextStyle(color: Colors.white,fontSize:20.0),
//                     ))),
//             Expanded(flex: 1, child: coursePrice)
//           ],
//         ),
//       ],
//     );
//
//     final topContent = Stack(
//       children: <Widget>[
//         Container(
//             padding: EdgeInsets.only(left: 10.0),
//             height: MediaQuery.of(context).size.height * 0.5,
//             decoration: new BoxDecoration(
//               image: new DecorationImage(
//                 image: new NetworkImage(curUserImg),
//                 fit: BoxFit.cover,
//               ),
//             )),
//         Container(
//           height: MediaQuery.of(context).size.height * 0.5,
//           padding: EdgeInsets.all(40.0),
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
//           child: Center(
//             child: topContentText,
//           ),
//         ),
//         Positioned(
//           left: 8.0,
//           top: 60.0,
//           child: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child:
//             Icon(Icons.arrow_back, color: Colors.white),
//           ),
//         )
//       ],
//     );
//
//     final bottomContentText = Text(
//       lesson.content,
//       style: TextStyle(fontSize: 18.0),
//     );
//     // final readButton = Container(
//     //     padding: EdgeInsets.symmetric(vertical: 16.0),
//     //     width: MediaQuery.of(context).size.width,
//     //     child: RaisedButton(
//     //       onPressed: () => {},
//     //       color: Color.fromRGBO(58, 66, 86, 1.0),
//     //       child:
//     //       Text("TAKE THIS LESSON", style: TextStyle(color: Colors.white)),
//     //     ));
//     final bottomContent = Container(
//       width: MediaQuery.of(context).size.width,
//       padding: EdgeInsets.all(40.0),
//       child: Center(
//         child: Column(
//           children: <Widget>[bottomContentText],
//         ),
//       ),
//     );
//
//
//     return Scaffold(
//       body: Column(
//         children: <Widget>[topContent, bottomContent],
//       ),
//       floatingActionButton:FloatingActionButton(
//         tooltip: "发布一条语音",
//         splashColor:Colors.greenAccent,
//         child: Icon(Icons.add),
//         onPressed: (){
//           // addNewAudio(context);
//           // router.navigateTo(context, 'record');
//           router.navigateTo(context, 'record');
//         },
//
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//
//     );
//   }
//
//   Future<void> addNewAudio(BuildContext context) async {
//     return await showDialog(context: context,
//         builder: (context){
//           // bool isChecked = false;
//           return StatefulBuilder(builder: (context,setState){
//             return AlertDialog(
//               content: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       TextFormField(
//                         controller: _headerEditingController,
//                         validator: (value){
//                           return value.isNotEmpty ? null : "没有说明别人也看不懂啊";
//                         },
//                         decoration: InputDecoration(hintText: "解释语言"),
//                       ),
//                       // TextFormField(
//                       //   controller: _contentEditingController,
//                       //   maxLines: 10,
//                       //   minLines: 5,
//                       //   decoration: InputDecoration(hintText: "输入描述"),
//                       // ),
//                       SizedBox(
//                         height: 40,
//                       ),
//                       // RecordPage(),
//                       AudioHome(),
//                     ],
//                   )),
//               actions: <Widget>[
//                 TextButton(
//                   child: Text('创建'),
//                   onPressed: () async {
//                     if(_formKey.currentState.validate()){
//                       String tableId;
//                       //向CollectionTableAdd一个空表
//                       var now = new DateTime.now();
//                       Navigator.of(context).pop();
//                     }
//                   },
//                 ),
//                 TextButton(
//                   child: Text('取消'),
//                   onPressed: (){
//                     Navigator.of(context).pop();
//                   },
//                 )
//               ],
//             );
//           });
//         });
//   }
//
//
// }