import 'package:blossom_accents/common/application.dart';
import 'package:shared_preferences/shared_preferences.dart';

sharedAddData(String key,Object dataType,Object data) async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  switch(dataType){
    case bool:
      prefs.setBool(key, data as bool);break;
    case double:
      prefs.setDouble(key, data as double);break;
    case int:
      prefs.setInt(key, data as int);break;
    case String:
      prefs.setString(key, data as String);break;
    case List:
      prefs.setStringList(key, data as List<String>);break;
    default:
      prefs.setString(key, data as String);break;
  }
}

Future<Object> sharedGetData(String key) async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  return prefs.get(key);
}

Future<void> sharedDeleteData(String key) async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  prefs.remove(key);
}

sharedAlterData(String key,Object dataType,Object value) async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  prefs.remove(key);
  sharedAddData(key,dataType,value);

}
Future<void>sharedDeleteAll() async{
  SharedPreferences prefs=await SharedPreferences.getInstance();
  // prefs.clear();
  prefs.remove(USER_EMAIL);
  prefs.remove(USER_LOGIN);
}



