import 'package:flutter/material.dart';
import 'text_field_container.dart';
import 'package:blossom_accents/common/application.dart';
class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);
  bool visible=true;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: visible,
        onChanged: onChanged,
        cursorColor: color6,
        decoration: InputDecoration(
          hintText: "密码",
          icon: Icon(
            Icons.lock,
            color: color6,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
