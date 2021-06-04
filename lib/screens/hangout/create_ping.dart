import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/data/model/hangout/PollModel.dart';
import 'package:ipecstudentsapp/screens/hangout/widget/basic_ping.dart';
import 'package:ipecstudentsapp/screens/hangout/widget/pollsWidget.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import 'widget/bottomCompose.dart';

class CreatePing extends StatefulWidget {
  static const String ROUTE = "/createPing";
  const CreatePing({key}) : super(key: key);

  @override
  _CreatePingState createState() => _CreatePingState();
}

class _CreatePingState extends State<CreatePing> {
  final textEditingController = TextEditingController();
  final focusNode = FocusNode();

  List<Widget> addtionalChildren = [];
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      new GlobalKey<ScaffoldMessengerState>();

  bool isImage, isLink, isPoll = false;
  String imageUrl, link;
  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    textEditingController.dispose();

    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(50),
                      child: Ink(
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          Icons.close,
                          size: 30,
                        ),
                      ),
                    ),
                    FloatingActionButton.extended(
                      onPressed: () {},
                      label: Text(
                        'Post',
                        style: TextStyle(color: Colors.black),
                      ),
                      icon: Icon(
                        Icons.send,
                        color: Colors.black,
                      ),
                      backgroundColor: kPurple,
                    )
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      composeArea(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: addtionalChildren,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  children: [
                    kMedWidthPadding,
                    BottomCompose(
                        title: 'Image',
                        icon: Icons.image,
                        onPress: () {
                          setState(() {
                            if (addtionalChildren.length <= 0) {
                              imageUrl = 'hello';
                              addtionalChildren.add(Stack(
                                children: [
                                  Image.asset('assets/images/coworkers.png'),
                                  removeWidget(),
                                ],
                              ));
                            } else {
                              print("Remove older attachmnet");
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                    'You have already attached something. Remove the older attachment first'),
                              ));
                            }
                          });
                        }),
                    BottomCompose(
                        title: 'Gif',
                        icon: Icons.animation,
                        onPress: () {
                          setState(() {
                            if (addtionalChildren.length <= 0) {
                              imageUrl = 'hello';
                              addtionalChildren.add(Stack(
                                children: [
                                  Image.asset('assets/images/coworkers.png'),
                                  removeWidget(),
                                ],
                              ));
                            } else {
                              print("Remove older attachmnet");
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                    'You have already attached something. Remove the older attachment first'),
                              ));
                            }
                          });
                        }),
                    BottomCompose(
                        title: 'Link', icon: Icons.link, onPress: () {}),
                    BottomCompose(
                        title: 'Poll',
                        icon: Icons.poll,
                        onPress: () {
                          setState(() {
                            if (addtionalChildren.length <= 0) {
                              addtionalChildren.add(Stack(
                                children: [
                                  PollView(
                                    poll: PollModel(
                                        creator: '', optionLabel: ["1", "2"]),
                                    user: '',
                                    isCreate: true,
                                  ),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: removeWidget()),
                                ],
                              ));
                            } else {
                              print("Remove older attachmnet");
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                    'You have already attached something. Remove the older attachment first'),
                              ));
                            }
                          });
                        }),
                    kMedWidthPadding,
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  IconButton removeWidget() {
    return IconButton(
      color: Colors.red,
      icon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.remove_circle,
          size: 30,
        ),
      ),
      onPressed: () {
        addtionalChildren = [];
        isImage = false;
        isLink = false;
        isPoll = false;
        link = '';
        imageUrl = '';
        setState(() {});
      },
    );
  }

  Widget composeArea() {
    return Container(
      // color: Colors.red,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: textEditingController,
        onChanged: (text) {},
        maxLines: null,
        maxLength: 200,
        focusNode: focusNode,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(fontWeight: FontWeight.normal),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Write here...',
            hintStyle: TextStyle(fontSize: 20, color: kLightGrey)),
      ),
    );
  }
}
