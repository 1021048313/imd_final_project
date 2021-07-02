import 'package:flutter/material.dart';
import 'text_field_container.dart';
import 'package:blossom_accents/common/application.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: color6,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: color6,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
