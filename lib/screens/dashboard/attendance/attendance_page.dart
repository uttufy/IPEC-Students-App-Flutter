import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ipecstudents/data/repo/session.dart';
import 'package:ipecstudents/screens/dashboard/attendance/attendance_screen.dart';
import 'package:ipecstudents/screens/dashboard/attendance/myLocalWebview.dart';
import 'package:ipecstudents/util/SizeConfig.dart';
import 'package:ipecstudents/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AttendancePage extends StatefulWidget {
  static const String ROUTE = "/AttendancePage";
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyLocalWebView(),
        DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return AttendanceScreen(scrollController: scrollController);
          },
        ),
      ],
    );
  }
}
