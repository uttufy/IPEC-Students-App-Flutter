import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../data/repo/auth.dart';
import '../../data/repo/pings.dart';
import 'create_ping.dart';
import 'widget/basic_ping.dart';

class HangoutFeedScreen extends StatefulWidget {
  static const String ROUTE = "/feed";
  final Pings pings;
  const HangoutFeedScreen({
    Key key,
    @required this.pings,
  }) : super(key: key);

  @override
  _HangoutFeedScreenState createState() => _HangoutFeedScreenState();
}

class _HangoutFeedScreenState extends State<HangoutFeedScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  int pageSize = 10; //database reference object
  final databaseRef =
      FirebaseDatabase.instance.reference().child('hangout').child('pings');

  _firebaseListeners() {
    databaseRef.onChildRemoved.listen((event) {
      widget.pings.deleteEvent(event.snapshot);
    });
    databaseRef.onChildAdded.listen((event) {
      widget.pings.addEvent(event.snapshot);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.pings.loadPings(pageSize);
    _firebaseListeners();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(builder: (context, auth, child) {
      return Consumer<Pings>(builder: (context, pings, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(context, CreatePing.ROUTE,
                  arguments: {'user': auth.hUser});
            },
            label: Text('Ping'),
            icon: Icon(Icons.flash_on),
          ),
          body: ListView.builder(
            padding:
                const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 80),
            itemBuilder: (c, i) {
              final item = pings.postItemsList[i];
              if (item.reports > 0)
                return SizedBox();
              else
                return PingBasicWidget(
                  item: item,
                  userId: auth.hUser.id,
                );
            },
            itemCount: pings.postItemsList.length,
          ),
        );
      });
    });
  }
}
