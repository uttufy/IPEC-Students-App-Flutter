import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/screens/hangout/create_ping.dart';
import 'package:ipecstudentsapp/screens/hangout/widget/basic_ping.dart';
import 'package:ipecstudentsapp/theme/colors.dart';

class HangoutFeedScreen extends StatefulWidget {
  static const String ROUTE = "/feed";
  const HangoutFeedScreen({
    Key key,
  }) : super(key: key);

  @override
  _HangoutFeedScreenState createState() => _HangoutFeedScreenState();
}

class _HangoutFeedScreenState extends State<HangoutFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, CreatePing.ROUTE);
        },
        label: Text('Ping'),
        icon: Icon(Icons.send),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            PingBasicWidget(
                name: 'UTKARSH SHARMA',
                havePhoto: true,
                pingTxt:
                    "Only after disaster can we be resurrected. It's only after you've lost everything that you're free to do anything. Nothing is static, everything is evolving, everything is falling apart.",
                imageURl:
                    "https://miro.medium.com/max/800/0*QTqcHXF1RgSRlien.png",
                isLinkAttached: true,
                url: "https://miro.medium.com/max/800/0*QTqcHXF1RgSRlien.png"),
            PingBasicWidget(
                name: 'UTKARSH SHARMA',
                havePhoto: false,
                pingTxt:
                    "Only after disaster can we be resurrected. It's only after you've lost everything that you're free to do anything. Nothing is static, everything is evolving, everything is falling apart.",
                isLinkAttached: true,
                url: "https://miro.medium.com/max/800/0*QTqcHXF1RgSRlien.png"),
          ],
        ),
      ),
    );
  }
}
