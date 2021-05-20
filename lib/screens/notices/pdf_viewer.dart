import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../data/model/Notice.dart';

class PdfScreen extends StatefulWidget {
  final String url;
  final Notice notice;

  const PdfScreen({Key key, @required this.url, @required this.notice})
      : super(key: key);
  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.notice.title),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
                onTap: () {
                  Share.share("""IPEC Notice
----
Title : ${widget.notice.title}
Date : ${widget.notice.date}

Link [PDF] : ${Uri.parse(widget.url).toString()}
----
Contributed by : ${widget.notice.credit}
on IPEC Student's app 
Android :  http://bit.ly/ipecapp 
IOS : http://bit.ly/ipecappios
""", subject: 'IPEC Notice');
                },
                child: Icon(Icons.share)),
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.url,
      ),
    );
  }
}
