import 'package:ipecstudents/theme/colors.dart';
import 'package:ipecstudents/theme/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasicButton extends StatefulWidget {
  BasicButton(
      {this.onPress,
      @required this.title,
      this.buttonColor = kOrange,
      this.textColor = Colors.white});

  final String title;
  final VoidCallback onPress;
  final Color buttonColor;
  final Color textColor;

  @override
  _BasicButtonState createState() => _BasicButtonState();
}

class _BasicButtonState extends State<BasicButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(kLowCircleRadius),
      child: InkWell(
        onTap: widget.onPress,
        child: Ink(
          width: double.maxFinite,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.buttonColor,
            borderRadius: BorderRadius.circular(kLowCircleRadius),
          ),
          child: Center(
            child: Text(
              widget.title,
            ),
          ),
        ),
      ),
    );
  }
}

basicBackButton(context) => InkWell(
    onTap: () => Navigator.pop(context),
    borderRadius: BorderRadius.circular(kMedCircleRadius),
    child: Ink(
        padding: const EdgeInsets.all(10),
        child: Icon(
          Icons.arrow_back,
          color: Colors.black,
        )));
