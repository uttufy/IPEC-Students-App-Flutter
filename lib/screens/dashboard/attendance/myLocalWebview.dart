import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../data/repo/session.dart';

class MyLocalWebView extends StatefulWidget {
  static const String = "/MyLocalWebview";

  const MyLocalWebView({
    Key? key,
  }) : super(key: key);

  @override
  _MyLocalWebViewState createState() => _MyLocalWebViewState();
}

class _MyLocalWebViewState extends State<MyLocalWebView> {
  String html =
      "<h1 style=\"text-align: center; \"><strong>Something went wrong😞</strong></h1>";

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
      _loadTable(session);
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

  void _loadTable(Session session) {
    try {
      html = session.getTable();
    } catch (e) {
      print(e.toString());
      html =
          "<br><h1 style=\"text-align: center; font-size: 10em;font-family: sans-serif\"><strong>Failed to parse table</strong></h1><h2 style=\"text-align: center; font-size: 5em;font-family: sans-serif\"><strong>${e.toString()}</strong></h2>";
    }
  }
}
