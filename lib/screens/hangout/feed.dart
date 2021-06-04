import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/data/model/hangout/PollModel.dart';
import 'package:ipecstudentsapp/data/model/hangout/hangUser.dart';
import 'package:ipecstudentsapp/data/model/hangout/post.dart';
import 'package:ipecstudentsapp/data/repo/auth.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'create_ping.dart';
import 'widget/basic_ping.dart';

class HangoutFeedScreen extends StatefulWidget {
  static const String ROUTE = "/feed";
  const HangoutFeedScreen({
    Key key,
  }) : super(key: key);

  @override
  _HangoutFeedScreenState createState() => _HangoutFeedScreenState();
}

class _HangoutFeedScreenState extends State<HangoutFeedScreen> {
  List<Post> postItemsList = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final databaseRef =
      FirebaseDatabase.instance.reference().child('hangout').child('pings');

  int pageSize = 10; //database reference object

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
    await _onInit();
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Future<void> _onInit() async {
    var query = databaseRef.orderByChild('postedOn').limitToFirst(pageSize);
    try {
      final snapshot = await query.once();
      var keys = snapshot.value.keys;
      var data = snapshot.value;

      for (var indivisualKey in keys) {
        Post postItem = new Post(
            id: data[indivisualKey]['id'],
            author: Huser.fromMap(data[indivisualKey]['author']),
            authorImage: data[indivisualKey]['authorImage'],
            postedOn: data[indivisualKey]['postedOn'],
            text: data[indivisualKey]['text'],
            likes: data[indivisualKey]['likes'],
            comments: data[indivisualKey]['comments'],
            reports: data[indivisualKey]['reports'],
            isLinkAttached: data[indivisualKey]['isLinkAttached'],
            link: data[indivisualKey]['link'],
            isImage: data[indivisualKey]['isImage'],
            imageUrl: data[indivisualKey]['imageUrl'],
            isPoll: data[indivisualKey]['isPoll'],
            pollData: PollModel.fromMap(data[indivisualKey]['pollData']),
            gifUrl: data[indivisualKey]['gifUrl'],
            isGif: data[indivisualKey]['isGif']);
        if (!(postItemsList.contains(postItem))) postItemsList.add(postItem);
      }
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(builder: (context, auth, child) {
      return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, CreatePing.ROUTE,
                arguments: {'user': auth.hUser});
          },
          label: Text('Ping'),
          icon: Icon(Icons.send),
        ),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Text("pull up load");
              } else if (mode == LoadStatus.loading) {
                body = CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = Text("Load Failed!Click retry!");
              } else if (mode == LoadStatus.canLoading) {
                body = Text("release to load more");
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            itemBuilder: (c, i) {
              final item = postItemsList[i];
              return PingBasicWidget(
                item: item,
                name: auth.hUser.name,
              );
            },
            // itemExtent: 100.0,
            itemCount: postItemsList.length,
          ),
        ),
      );
      // SingleChildScrollView(
      //   physics: BouncingScrollPhysics(),
      //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
      //   child: Column(
      //     children: [
      //       PingBasicWidget(
      //           name: 'UTKARSH SHARMA',
      //           havePhoto: true,
      //           pingTxt:
      //               "Only after disaster can we be resurrected. It's only after you've lost everything that you're free to do anything. Nothing is static, everything is evolving, everything is falling apart.",
      //           imageURl:
      //               "https://miro.medium.com/max/800/0*QTqcHXF1RgSRlien.png",
      //           isLinkAttached: true,
      //           url:
      //               "https://miro.medium.com/max/800/0*QTqcHXF1RgSRlien.png"),
      //       PingBasicWidget(
      //           name: 'UTKARSH SHARMA',
      //           havePhoto: false,
      //           pingTxt:
      //               "Only after disaster can we be resurrected. It's only after you've lost everything that you're free to do anything. Nothing is static, everything is evolving, everything is falling apart.",
      //           isLinkAttached: true,
      //           url:
      //               "https://miro.medium.com/max/800/0*QTqcHXF1RgSRlien.png"),
      //     ],
      //   ),
      // ),
    });
  }
}
