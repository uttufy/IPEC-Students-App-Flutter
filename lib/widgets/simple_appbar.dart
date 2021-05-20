import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

import '../util/SizeConfig.dart';

class SimpleAppBar extends StatelessWidget {
  final img;
  final VoidCallback onPic;
  final VoidCallback onBack;
  final String title;
  const SimpleAppBar(
      {Key key, this.img, this.onPic, @required this.onBack, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(50),
            child: Ink(
              padding: const EdgeInsets.all(15),
              child: Icon(
                Icons.chevron_left,
                size: 30,
              ),
            ),
          ),
          img != null
              ? GestureDetector(
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
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
        ],
      ),
    );
  }
}
