import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:provider/provider.dart';

import '../../data/bad_hindi_words.dart';
import '../../data/model/hangout/comment.dart';
import '../../data/model/hangout/hangUser.dart';
import '../../data/model/hangout/post.dart';
import '../../data/repo/pings.dart';
import '../../theme/colors.dart';
import '../../widgets/simple_appbar.dart';
import 'chatters.dart';
import 'widget/basic_ping.dart';
import 'widget/removeButton.dart';

class ChatterScreen extends StatefulWidget {
  static const String ROUTE = "/chatter";
  final Post? post;

  const ChatterScreen({Key? key, this.post}) : super(key: key);

  @override
  _ChatterScreenState createState() => _ChatterScreenState();
}

class _ChatterScreenState extends State<ChatterScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final filter = ProfanityFilter.filterAdditionally(badwordsHindi);
  bool isLoading = false;
  bool isGif = false;
  String? gifUrl = "";

  Widget additionalWidget = Container();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      new GlobalKey<ScaffoldMessengerState>();
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;

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
                    bgColor: isDark ? kGrey : null,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          NeumorphicButton(
                            onPressed: () {
                              // return _launchURL(notices[index].link);
                            },
                            padding: const EdgeInsets.all(20),
                            style: NeumorphicStyle(
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20))),
                                depth: isDark ? 5 : 8,
                                lightSource: LightSource.top,
                                shadowDarkColor: isDark ? Colors.black12 : null,
                                shadowLightColor:
                                    isDark ? Colors.black45 : null,
                                color: isDark ? kGrey : Colors.white),
                            child: PingBasicWidget(
                              item: widget.post,
                              userId: pings.hUser!.id,
                              detailedView: true,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Chatters(
                              postID: widget.post!.id,
                              currentUserID: pings.hUser!.id,
                            ),
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
    return Column(
      children: [
        additionalWidget,
        Stack(
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
                          GestureDetector(
                            onTap: () {
                              addGif(context);
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.greenAccent
                                    : Colors.lightBlue,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                Icons.add,
                                color: isDark ? Colors.black : Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextField(
                              controller: textEditingController,
                              onChanged: (text) {
                                if (filter.hasProfanity(text)) {
                                  _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                      content: Text(
                                          'Bad words detected... Beware any bad activity will lead to straight up ban')));
                                  textEditingController.text =
                                      filter.censor(text);
                                }
                              },
                              maxLength: 200,
                              decoration: InputDecoration(
                                  hintText: "Write a comment...",
                                  counterText: "",
                                  hintStyle: TextStyle(
                                      color: isDark
                                          ? Colors.white54
                                          : Colors.black54),
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
        ),
      ],
    );
  }

  Future<void> addGif(BuildContext context) async {
    if (isGif == false) {
      final gif = await GiphyPicker.pickGif(
          context: context, apiKey: 'cXIAL2LDuPM9W8HaqDItOQm3i3guL0bt');
      if (gif != null) {
        print(gifUrl);
        gifUrl = gif.images.original!.url;
        isGif = true;
        additionalWidget = Stack(
          children: [
            Image.network(
              gifUrl!,
              height: 100,
            ),
            removeWidget(onRemoved),
          ],
        );
      }
    } else {
      print("Remove older attachmnet");
      _scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text(
            'You have already attached something. Remove the older attachment first'),
      ));
    }
    setState(() {});
  }

  onRemoved() {
    setState(() {
      isGif = false;
      gifUrl = "";
      additionalWidget = SizedBox();
    });
  }

  void _onSubmit(
    Pings pings,
  ) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (textEditingController.text.trim().isNotEmpty || isGif) {
      if (filter.hasProfanity(textEditingController.text)) {
        _scaffoldKey.currentState!.showSnackBar(
            SnackBar(content: Text("Bad language is not allowed!!!")));
        return;
      }
      isLoading = true;
      setState(() {});

      int epoch = DateTime.now().microsecondsSinceEpoch;

      if (gifUrl!.isEmpty) isGif = false;
      final authorUser = Huser(
          id: pings.hUser!.id,
          name: pings.hUser!.name,
          email: "",
          gender: "",
          phone: "",
          depart: pings.hUser!.depart,
          yr: pings.hUser!.yr,
          section: pings.hUser!.section,
          likes: []);

      final res = CommentModel(
          id: widget.post!.id,
          author: authorUser,
          authorImage: "https://robohash.org/${pings.hUser!.id}",
          postedOn: epoch,
          text: textEditingController.text.trim(),
          gifUrl: gifUrl,
          isGif: isGif,
          reports: 0);

      try {
        final ref = FirebaseDatabase.instance
            .reference()
            .child('hangout')
            .child('comments')
            .child('${widget.post!.id}');
        ref.push().set(res.toMap());

        _scaffoldKey.currentState!
            .showSnackBar(SnackBar(content: Text("Chattered!!!")));

        textEditingController.text = "";

        pings.addComment(widget.post!.id, res);
        additionalWidget = SizedBox();
        isGif = false;
        gifUrl = "";
        isLoading = false;
        setState(() {});
      } catch (e) {
        isLoading = false;
        setState(() {});
        print(e.toString());
        _scaffoldKey.currentState!
            .showSnackBar(SnackBar(content: Text("Retry: ${e.toString()}")));
      }
    } else {
      _scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text("Empty is not allowed!!!")));
    }
  }
}
