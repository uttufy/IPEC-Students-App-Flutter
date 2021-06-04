import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/theme/colors.dart';
import 'package:ipecstudentsapp/theme/style.dart';

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
                      label: Text('Post Ping'),
                      icon: Icon(Icons.send),
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
                      Column(
                        children: addtionalChildren,
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
                          print(addtionalChildren.length);
                          setState(() {
                            if (addtionalChildren.length <= 0)
                              addtionalChildren.add(Stack(
                                children: [
                                  Image.asset('assets/images/coworker.png'),
                                  Icon(Icons.remove_circle)
                                ],
                              ));
                            else {
                              print("Remove older attachmnet");
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                    'You have already attached something. Remove the older attachment first'),
                              ));
                            }
                          });
                        }),
                    BottomCompose(
                        title: 'Gif', icon: Icons.animation, onPress: () {}),
                    BottomCompose(
                        title: 'Link', icon: Icons.link, onPress: () {}),
                    BottomCompose(
                        title: 'Poll', icon: Icons.poll, onPress: () {}),
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

class BottomCompose extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;

  const BottomCompose({
    Key key,
    this.title,
    this.icon,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: kPurple,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            kLowWidthPadding,
            Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
