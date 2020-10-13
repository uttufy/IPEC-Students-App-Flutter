import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ipecstudents/data/repo/session.dart';
import 'package:ipecstudents/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyLocalWebView extends StatefulWidget {
  static const String = "/MyLocalWebview";

  const MyLocalWebView({
    Key key,
  }) : super(key: key);

  @override
  _MyLocalWebViewState createState() => _MyLocalWebViewState();
}

class _MyLocalWebViewState extends State<MyLocalWebView> {
  String html = "<h1><strong>Something went wrong</strong></h1>";

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Session>(
      builder: (context, session, child) {
        return Scaffold(
          body: SafeArea(
            child: _getBody(session),
          ),
        );
      },
    );
  }

  Widget _getBody(Session session) {
    bool loading = true;
    if (session.attendanceStatus == AttendanceStatus.Loading || loading) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    } else if (session.attendanceStatus == AttendanceStatus.Loaded) {
      html = session.getTable();
      int i = 0;
      while (i < 10) html += " <br> ";
      return WebView(
        initialUrl: Uri.dataFromString(html, mimeType: 'text/html').toString(),
        gestureNavigationEnabled: false,
        onPageStarted: (_) {
          setState(() {
            loading = true;
          });
        },
        onPageFinished: (_) {
          setState(() {
            loading = false;
          });
        },
      );
    } else if (session.attendanceStatus == AttendanceStatus.Init)
      return Center(child: Text('Intializing'));
    else
      return Center(child: Text('Something went wrong'));
  }
}
