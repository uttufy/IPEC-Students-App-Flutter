import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/data/model/hangout/post.dart';
import 'package:ipecstudentsapp/screens/hangout/widget/basic_ping.dart';
import 'package:ipecstudentsapp/widgets/simple_appbar.dart';
import 'package:provider/provider.dart';

class ChatterScreen extends StatefulWidget {
  static const String ROUTE = "/chatter";
  final Post post;
  const ChatterScreen({Key key, this.post}) : super(key: key);

  @override
  _ChatterScreenState createState() => _ChatterScreenState();
}

class _ChatterScreenState extends State<ChatterScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, pings, child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                SimpleAppBar(
                  onBack: () {
                    Navigator.pop(context);
                  },
                  title: 'Ping',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      PingBasicWidget(
                        item: widget.post,
                        userId: pings.hUser.id,
                        detailedView: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
