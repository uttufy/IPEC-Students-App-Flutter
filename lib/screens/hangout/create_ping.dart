import 'dart:io';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/repo/pings.dart';
import 'widget/linked_widget.dart';
import 'widget/removeButton.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:provider/provider.dart';
import '../../data/bad_hindi_words.dart';
import '../../data/model/hangout/PollModel.dart';
import '../../data/model/hangout/hangUser.dart';
import '../../data/model/hangout/post.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../widgets/loading_widget.dart';
import 'widget/bottomCompose.dart';
import 'widget/pollsWidget.dart';

class CreatePing extends StatefulWidget {
  static const String ROUTE = "/createPing";
  final Huser? user;
  const CreatePing({key, required this.user}) : super(key: key);

  @override
  _CreatePingState createState() => _CreatePingState();
}

class _CreatePingState extends State<CreatePing> {
  final textEditingController = TextEditingController();
  final focusNode = FocusNode();

  List<Widget> addtionalChildren = [];
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      new GlobalKey<ScaffoldMessengerState>();
  final filter = ProfanityFilter.filterAdditionally(badwordsHindi);

  bool isImage = false;
  bool isLink = false;
  bool isPoll = false;
  bool isGif = false;
  // String imageUrl = "";
  String? gifUrl = "";
  String link = "";
  String option1 = "";
  String option2 = "";

  bool isLoading = false;

  late File _image;
  final picker = ImagePicker();

  PollModel? pollModel;

  Future getImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80);

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
          child: isLoading
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => setState(() {
                          isLoading = false;
                        }),
                        borderRadius: BorderRadius.circular(50),
                        child: Ink(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.close,
                            size: 30,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(child: LoadingWidget()),
                      ),
                    ],
                  ),
                )
              : Column(
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
                              // style: TextStyle(color: Colors.black),
                            ),
                            icon: Icon(
                              Icons.send,
                              // color: Colors.black,
                            ),
                            // backgroundColor: kPurple,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
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
                                    getImage().then((value) {
                                      isImage = true;
                                      setState(() {
                                        addtionalChildren.add(Stack(
                                          children: [
                                            Image.file(_image),
                                            removeWidget(onRemove),
                                          ],
                                        ));
                                      });
                                    });
                                  } else {
                                    print("Remove older attachmnet");
                                    _scaffoldKey.currentState!
                                        .showSnackBar(SnackBar(
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
                                  _scaffoldKey.currentState!
                                      .showSnackBar(SnackBar(
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
                                    _scaffoldKey.currentState!
                                        .showSnackBar(SnackBar(
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
      if (gif != null) {
        print(gifUrl);
        gifUrl = gif.images.original!.url;
        isGif = true;
        addtionalChildren.add(Stack(
          children: [
            Image.network(
              gifUrl!,
            ),
            removeWidget(onRemove),
          ],
        ));
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

  onRemove() {
    addtionalChildren = [];
    isImage = false;
    isLink = false;
    isPoll = false;
    isGif = false;
    gifUrl = "";
    link = '';

    // imageUrl = '';
    setState(() {});
  }

  Widget composeArea() {
    return Container(
      // color: Colors.red,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: textEditingController,
        onChanged: (text) {
          if (filter.hasProfanity(text)) {
            _scaffoldKey.currentState!.showSnackBar(SnackBar(
                content: Text(
                    'Bad words detected... Beware any bad activity will lead to straight up ban')));
            textEditingController.text = filter.censor(text);
          }
        },
        maxLines: null,
        maxLength: 200,
        focusNode: focusNode,
        style: Theme.of(context)
            .textTheme
            .headline6!
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
            // ignore: deprecated_member_use
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            // ignore: deprecated_member_use
            new FlatButton(
                child: const Text('SAVE'),
                onPressed: () {
                  if (link.isNotEmpty) {
                    isLink = true;
                    Navigator.pop(context);
                    addtionalChildren.add(Stack(
                      children: [
                        LinkWidget(link),
                        Align(
                            alignment: Alignment.centerRight,
                            child: removeWidget(onRemove)),
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
            // ignore: deprecated_member_use
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            // ignore: deprecated_member_use
            new FlatButton(
                child: const Text('SAVE'),
                onPressed: () {
                  if (option1.isNotEmpty && option2.isNotEmpty) {
                    isPoll = true;
                    pollModel = PollModel(
                        creator: widget.user!.id,
                        optionLabel: [option1, option2]);
                    addtionalChildren.add(Stack(
                      children: [
                        PollView(
                          poll: pollModel,
                          user: widget.user!.id,
                          isCreate: true,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: removeWidget(onRemove)),
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

  Future<void> _onSubmit() async {
    isLoading = true;
    setState(() {});
    String _imageUrl = "";
    int epoch = DateTime.now().microsecondsSinceEpoch;

    PollModel _poll =
        PollModel(creator: widget.user!.id, optionLabel: [option1, option2]);
    try {
      if (isImage) {
        var snapshot = await FirebaseStorage.instance
            .ref()
            .child('images/${widget.user!.id! + "_" + generateRandomString(5)}')
            .putFile(_image);
        _imageUrl = await snapshot.ref.getDownloadURL();
      }
      if (gifUrl!.isEmpty) isGif = false;
      if (_imageUrl.isEmpty) isImage = false;
      if (link.isEmpty) isLink = false;
      final authorUser = Huser(
          id: widget.user!.id,
          name: widget.user!.name,
          email: "",
          gender: "",
          phone: "",
          depart: widget.user!.depart,
          yr: widget.user!.yr,
          section: widget.user!.section,
          likes: []);
      final res = Post(
          id: widget.user!.id! + "_" + epoch.toString(),
          author: authorUser,
          authorImage: "https://robohash.org/${widget.user!.id}",
          postedOn: epoch,
          text: textEditingController.text,
          link: link,
          imageUrl: _imageUrl,
          isImage: isImage,
          isLinkAttached: isLink,
          isPoll: isPoll,
          pollData: _poll,
          gifUrl: gifUrl,
          isGif: isGif);

      FirebaseDatabase.instance
          .reference()
          .child('hangout')
          .child('pings')
          // .push()
          .child('${widget.user!.id! + "_" + epoch.toString()}')
          .set(res.toMap());
      _scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text("Pinged!!!")));
      Provider.of<Pings>(context, listen: false).addPost(res);
      Future.delayed(Duration(seconds: 2))
          .then((value) => Navigator.pop(context));
    } catch (e) {
      isLoading = false;
      setState(() {});
      print(e.toString());
      _scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text("Retry: ${e.toString()}")));
    }
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }
}
