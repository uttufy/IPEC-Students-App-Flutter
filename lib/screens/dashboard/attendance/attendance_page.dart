import 'package:flutter/material.dart';
import 'attendance_screen.dart';
import 'myLocalWebview.dart';
import '../../../util/SizeConfig.dart';

class AttendancePage extends StatefulWidget {
  static const String ROUTE = "/AttendancePage";
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 20),
            child: Scaffold(body: MyLocalWebView()),
          ),
          DraggableScrollableSheet(
            initialChildSize: 1,
            minChildSize: 0.15,
            builder: (context, scrollController) {
              return AttendanceScreen(scrollController: scrollController);
            },
          ),
        ],
      ),
    );
  }
}
