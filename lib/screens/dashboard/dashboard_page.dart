import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ipecstudents/data/repo/auth.dart';
import 'package:ipecstudents/theme/colors.dart';
import 'package:ipecstudents/theme/style.dart';
import 'package:ipecstudents/util/SizeConfig.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  static const String ROUTE = '/Dashboard';
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, child) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: SizeConfig.widthMultiplier * 7,
                    backgroundImage: MemoryImage(
                      base64Decode(auth.user.img.toString().split(',')[1]),
                    ),
                  ),
                  kHighPadding,
                  Text(
                    'Hello,',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Colors.black),
                  ),
                  Text(
                    auth.user.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            optionIcon('assets/icons/Bag.png', 'Attendance'),
                            optionIcon('assets/icons/Atom.png', 'Notices'),
                          ],
                        ),
                        kMedPadding,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            optionIcon(
                                'assets/icons/Boy-Student.png', 'Learning'),
                            optionIcon('assets/icons/Compass.png', 'About'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget optionIcon(String img, String title) {
    return Flexible(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(30),
        highlightColor: kPrimaryLightColor,
        child: Ink(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                img,
                width: SizeConfig.widthMultiplier * 15,
              ),
              kLowPadding,
              Text(
                title,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
