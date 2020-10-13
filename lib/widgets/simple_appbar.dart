import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ipecstudents/util/SizeConfig.dart';

class SimpleAppBar extends StatelessWidget {
  final img;
  final VoidCallback onPic;
  const SimpleAppBar({Key key, this.img, this.onPic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.maybePop(context);
            },
            borderRadius: BorderRadius.circular(50),
            child: Ink(
              padding: const EdgeInsets.all(15),
              child: Icon(
                Icons.chevron_left,
                size: 30,
              ),
            ),
          ),
          GestureDetector(
            onTap: onPic,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: SizeConfig.widthMultiplier * 5,
                backgroundImage: MemoryImage(
                  base64Decode(img),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
