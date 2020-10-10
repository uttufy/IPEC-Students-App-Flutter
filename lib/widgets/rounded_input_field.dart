import 'package:flutter/material.dart';
import 'package:ipecstudents/data/const.dart';
import 'package:ipecstudents/theme/colors.dart';
import 'package:ipecstudents/widgets/text_field_container.dart';

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
