import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/data/bad_hindi_words.dart';
import 'package:ipecstudentsapp/data/model/hangout/comment.dart';
import 'package:ipecstudentsapp/data/model/hangout/hangUser.dart';
import 'package:ipecstudentsapp/data/model/hangout/post.dart';
import 'package:ipecstudentsapp/data/repo/pings.dart';
import 'package:ipecstudentsapp/screens/hangout/chatters.dart';
import 'package:ipecstudentsapp/screens/hangout/widget/basic_ping.dart';
import 'package:ipecstudentsapp/widgets/simple_appbar.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:provider/provider.dart';

class ChatterScreen extends StatefulWidget {
  static const String ROUTE = "/chatter";
  final Post post;

  const ChatterScreen({Key key, this.post}) : super(key: key);

  @override
  _ChatterScreenState createState() => _ChatterScreenState();
}

class _ChatterScreenState extends State<ChatterScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final filter = ProfanityFilter.filterAdditionally(badwordsHindi);
  bool isLoading = false;
  bool isGif = false;
  String gifUrl = "";

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      new GlobalKey<ScaffoldMessengerState>();
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Pings>(
      builder: (context, pings, child) {
        return ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  SimpleAppBar(
                    onBack: () {
                      Navigator.pop(context);
                    },
                    title: 'Ping',
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          PingBasicWidget(
                            item: widget.post,
                            userId: pings.hUser.id,
                            detailedView: true,
                          ),
                          // CommentWidget(commentModel: ,),

                          Chatters(
                            postID: widget.post.id,
                            currentUserID: pings.hUser.id,
                          ),
                        ],
                      ),
                    ),
                  ),
                  _chatBox(pings),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _chatBox(Pings pings) {
    final isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
            height: 60,
            width: double.infinity,
            color: isDark ? Colors.grey.shade800 : Colors.white,
            child: isLoading
                ? Text('Loading...')
                : Row(
                    children: <Widget>[
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: Container(
                      //     height: 30,
                      //     width: 30,
                      //     decoration: BoxDecoration(
                      //       color:
                      //           isDark ? Colors.greenAccent : Colors.lightBlue,
                      //       borderRadius: BorderRadius.circular(30),
                      //     ),
                      //     child: Icon(
                      //       Icons.add,
                      //       color: isDark ? Colors.black : Colors.white,
                      //       size: 20,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          onChanged: (text) {
                            if (filter.hasProfanity(text)) {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      'Bad words detected... Beware any bad activity will lead to straight up ban')));
                              textEditingController.text = filter.censor(text);
                            }
                          },
                          maxLength: 200,
                          decoration: InputDecoration(
                              hintText: "Write a comment...",
                              counterText: "",
                              hintStyle: TextStyle(
                                  color:
                                      isDark ? Colors.white54 : Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          _onSubmit(pings);
                        },
                        child: Icon(
                          Icons.send,
                          // color: Colors.white,
                          size: 18,
                        ),
                        // backgroundColor: Colors.blue,
                        elevation: 0,
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  void _onSubmit(Pings pings) {
    if (textEditingController.text.isNotEmpty) {
      isLoading = true;
      setState(() {});

      int epoch = DateTime.now().millisecondsSinceEpoch;

      if (gifUrl.isEmpty) isGif = false;
      final authorUser = Huser(
          id: pings.hUser.id,
          name: pings.hUser.name,
          email: "",
          gender: "",
          phone: "",
          depart: pings.hUser.depart,
          yr: pings.hUser.yr,
          section: pings.hUser.section,
          likes: []);

      final res = CommentModel(
          id: pings.hUser.id + "_" + epoch.toString(),
          author: authorUser,
          authorImage: "https://robohash.org/${pings.hUser.id}",
          postedOn: epoch,
          text: textEditingController.text,
          gifUrl: gifUrl,
          isGif: isGif,
          reports: 0);

      try {
        final ref = FirebaseDatabase.instance
            .reference()
            .child('hangout')
            .child('comments')
            .child('${widget.post.id}');
        ref.push().set(res.toMap());

        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("Chattered!!!")));

        textEditingController.text = "";
        isLoading = false;
        setState(() {});
      } catch (e) {
        isLoading = false;
        setState(() {});
        print(e.toString());
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("Retry: ${e.toString()}")));
      }
    } else {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("Empty is not allowed!!!")));
    }
  }
}
