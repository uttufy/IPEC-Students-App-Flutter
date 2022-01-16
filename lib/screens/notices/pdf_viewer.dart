import 'package:flutter/material.dart';
import '../../util/msg_gen.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../data/model/Notice.dart';

class PdfScreen extends StatefulWidget {
  final String url;
  final Notice notice;

  const PdfScreen({Key? key, required this.url, required this.notice})
      : super(key: key);
  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  @override
  Widget build(BuildContext context) {
    // final _size = MediaQuery.of(context).size;
    // Widgets
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.notice.title!),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
                onTap: () {
                  Share.share(
                      genShareMessage(widget.notice.title, widget.notice.date,
                          widget.url, widget.notice.credit),
                      subject: 'IPEC Notice');
                },
                child: Icon(Icons.ios_share_sharp)),
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.url,
      ),
    );
  }
}
