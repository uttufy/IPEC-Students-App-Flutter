import 'dart:io';

import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:ipecstudentsapp/data/model/hangout/PollModel.dart';
import 'package:image_picker/image_picker.dart';
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
  String imageUrl, link, option1, option2;

  File _image;
  final picker = ImagePicker();

  PollModel pollModel;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

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
                      onPressed: () {
                        _onSubmit();
                      },
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
                              getImage();

                              imageUrl = 'hello';
                              addtionalChildren.add(Stack(
                                children: [
                                  Image.file(_image),
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
                          addGif(context);
                        }),
                    BottomCompose(
                        title: 'Link',
                        icon: Icons.link,
                        onPress: () {
                          if (addtionalChildren.length <= 0) {
                            _showLinkDialog();
                          } else {
                            print("Remove older attachmnet");
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                  'You have already attached something. Remove the older attachment first'),
                            ));
                          }
                        }),
                    BottomCompose(
                        title: 'Poll',
                        icon: Icons.poll,
                        onPress: () {
                          setState(() {
                            if (addtionalChildren.length <= 0) {
                              _showPollDialog();
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

  Future<void> addGif(BuildContext context) async {
    if (addtionalChildren.length <= 0) {
      final gif = await GiphyPicker.pickGif(
          context: context, apiKey: 'cXIAL2LDuPM9W8HaqDItOQm3i3guL0bt');
      imageUrl = gif.images.original.url;

      addtionalChildren.add(Stack(
        children: [
          Image.network(
            imageUrl,
          ),
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
    setState(() {});
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

  _showLinkDialog() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  autofocus: true,
                  onChanged: (v) {
                    link = v;
                  },
                  decoration: new InputDecoration(
                      labelText: 'Link', hintText: 'eg. https://google.com/'),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('SAVE'),
                onPressed: () {
                  if (link != null && link.isNotEmpty) {
                    isLink = true;
                    Navigator.pop(context);
                    addtionalChildren.add(Stack(
                      children: [
                        LinkWidget(link),
                        Align(
                            alignment: Alignment.centerRight,
                            child: removeWidget()),
                      ],
                    ));
                    setState(() {});
                  }
                })
          ],
        );
      },
    );
  }

  _showPollDialog() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: SizedBox(
            height: 200,
            child: Column(
              children: [
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new TextField(
                        autofocus: true,
                        onChanged: (v) {
                          option1 = v;
                        },
                        decoration: new InputDecoration(
                            labelText: 'Option 1', hintText: 'eg. Pizza'),
                      ),
                    )
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new TextField(
                        autofocus: true,
                        onChanged: (v) {
                          option2 = v;
                        },
                        decoration: new InputDecoration(
                            labelText: 'Option 2', hintText: 'eg. Burger'),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('SAVE'),
                onPressed: () {
                  if (option1 != null &&
                      option1.isNotEmpty &&
                      option2 != null &&
                      option2.isNotEmpty) {
                    isPoll = true;
                    pollModel = PollModel(
                        //TODO: User info
                        creator: '',
                        optionLabel: [option1, option2]);
                    addtionalChildren.add(Stack(
                      children: [
                        PollView(
                          poll: pollModel,
                          //TODO:USer
                          user: '',
                          isCreate: true,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: removeWidget()),
                      ],
                    ));

                    Navigator.pop(context);
                    setState(() {});
                  }
                })
          ],
        );
      },
    );
  }

  void _onSubmit() {
    //                     var snapshot = await _firebaseStorage.ref()
    // .child('images/imageName')
    // .putFile(file).onComplete;
    // var downloadUrl = await snapshot.ref.getDownloadURL();
  }
}
