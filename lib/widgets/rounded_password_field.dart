import 'package:flutter/material.dart';

import '../theme/colors.dart';
import 'text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  const RoundedPasswordField({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: !show,
        onChanged: widget.onChanged,
        cursorColor: kPrimaryColor,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: GestureDetector(
            onTap: () => setState(() {
              show = !show;
            }),
            child: Icon(
              show ? Icons.visibility_off : Icons.visibility,
              color: kPrimaryColor,
            ),
          ),
          border: InputBorder.none,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.black),
        ),
      ),
    );
  }
}
