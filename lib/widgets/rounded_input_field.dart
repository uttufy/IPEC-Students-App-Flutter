import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';
import 'text_field_container.dart';

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
        cursorColor: kPrimaryColor,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          hintStyle: Theme.of(context)
              .accentTextTheme
              .bodyText1
              .copyWith(color: Colors.black),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
