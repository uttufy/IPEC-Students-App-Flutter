import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:ipecstudentsapp/data/repo/session.dart';
import 'package:ipecstudentsapp/widgets/rounded_button.dart';
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
        return _getBody(session);
      },
    );
  }

  Widget _getBody(Session session) {
    if (session.attendanceStatus == AttendanceStatus.Loading) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    } else if (session.attendanceStatus == AttendanceStatus.Loaded) {
      html = session.getTable();
      return SafeArea(
        child: WebView(
          initialUrl:
              Uri.dataFromString(html, mimeType: 'text/html').toString(),
          gestureNavigationEnabled: true,
        ),
      );
    } else if (session.attendanceStatus == AttendanceStatus.Init)
      return Center(child: Text('Intializing'));
    else
      return Center(child: Text('Something went wrong'));
  }
}
