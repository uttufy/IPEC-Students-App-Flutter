import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/theme/colors.dart';
import 'package:ipecstudentsapp/widgets/general_dialog.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  int pageSize = 5; //database reference object
  final databaseRef =
      FirebaseDatabase.instance.reference().child('hangout').child('pings');

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    widget.pings.fetchMorePings();
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  _firebaseListeners() {
    databaseRef.onChildRemoved.listen((event) {
      widget.pings.deleteEvent(event.snapshot);
    });
    // databaseRef.onChildAdded.listen((event) {
    //   widget.pings.addEvent(event.snapshot);
    // });
  }

  @override
  void initState() {
    super.initState();
    _loadFeed();
    _firebaseListeners();
  }

  void _loadFeed() {
    try {
      widget.pings.loadPings(pageSize);
    } catch (e) {
      print(e.toString());
      GeneralDialog.show(context, title: 'Error', message: e.toString());
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Pings>(builder: (context, pings, child) {
      return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, CreatePing.ROUTE,
                arguments: {'user': pings.hUser});
          },
          label: Text('Ping'),
          icon: Icon(Icons.flash_on),
        ),
        body: SmartRefresher(
          // enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(
            waterDropColor: kPurple,
          ),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Text("Pull up load");
              } else if (mode == LoadStatus.loading) {
                body = CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = Text("Load Failed!Click retry!");
              } else if (mode == LoadStatus.canLoading) {
                body = Text("Release to load more");
              } else {
                body = Text("No more Data");
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding:
                const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 80),
            itemBuilder: (c, i) {
              final item = pings.postItemsList[i];
              if (item.reports > 0)
                return SizedBox();
              else
                return PingBasicWidget(
                  item: item,
                  userId: pings.hUser.id,
                );
            },
            itemCount: pings.postItemsList.length,
          ),
        ),
      );
    });
  }
}
