import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../theme/style.dart';

class BottomCompose extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;

  const BottomCompose({
    Key key,
    this.title,
    this.icon,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: kLighterGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.black,
            ),
            kLowWidthPadding,
            Text(
              title,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
