import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ipecstudents/data/repo/auth.dart';
import 'package:ipecstudents/screens/dashboard/attendance/graph.dart';
import 'package:ipecstudents/theme/style.dart';
import 'package:ipecstudents/util/SizeConfig.dart';
import 'package:ipecstudents/widgets/simple_appbar.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  static const String ROUTE = "/Attendance";
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, child) {
        return Scaffold(
          body: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SimpleAppBar(img: auth.user.img.toString().split(',')[1]),
              kLowPadding,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    Text(
                      'Overview',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              kHighPadding,
              Text(
                'Total Attendance',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Colors.black,
                    ),
              ),
              kLowPadding,
              Text(
                '80.10%',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              kLowPadding,
              AttendanceGraph(),
            ],
          )),
        );
      },
    );
  }
}
