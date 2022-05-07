import 'dart:convert';
import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:in_app_review/in_app_review.dart';
import '../sessional/sessional_screen.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_color/rainbow_color.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:is_first_run/is_first_run.dart';
import '../../data/repo/auth.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../util/SizeConfig.dart';
import '../../widgets/background.dart';
import '../about/about.dart';
import '../hangout/hangout_screen.dart';
import '../notices/notices_screen.dart';
import '../splash/splash_screen.dart';
import 'attendance/attendance_page.dart';

class DashboardScreen extends StatefulWidget {
  static const String ROUTE = '/Dashboard';
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      new GlobalKey<ScaffoldMessengerState>();
  final appLink = Platform.isIOS
      ? "https://apps.apple.com/us/app/ipec-students-app/id1568495067"
      : "https://play.google.com/store/apps/details?id=com.uttu.ipecstudentsapp&hl=en_IN&gl=US";
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final InAppReview inAppReview = InAppReview.instance;

  final Rainbow _rb = Rainbow(spectrum: const [
    kBlue, kGrey, kBlue
    // Colors.red,
    // Colors.orange,
    // Colors.yellow,
    // Colors.green,
    // Colors.blue,
    // Colors.indigo,
    // Colors.purple,
    // Colors.red,
  ], rangeStart: 0.0, rangeEnd: 10.0);

  @override
  void initState() {
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInAnonymously();
    reviewCheck();
    controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);

    animation = Tween<double>(
            begin: _rb.rangeStart.toDouble(), end: _rb.rangeEnd.toDouble())
        .animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
          controller.forward();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
    return Consumer<Auth>(
      builder: (context, auth, child) {
        return ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            body: UpgradeAlert(
              dialogStyle: UpgradeDialogStyle.cupertino,
              // debugLogging: true,
              // debugAlwaysUpgrade: true,
              shouldPopScope: () => true,
              child: Background(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: SizeConfig.widthMultiplier * 7,
                              backgroundImage: MemoryImage(
                                base64Decode(
                                    auth.user!.img.toString().split(',')[1]),
                              ),
                            ),
                            PopupMenuButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                icon: ImageIcon(AssetImage(
                                  'assets/icons/menu.png',
                                )),
                                onSelected: (dynamic value) {
                                  switch (value) {
                                    case 0:
                                      setState(() {
                                        if (isDark) {
                                          AdaptiveTheme.of(context).setLight();
                                        } else {
                                          AdaptiveTheme.of(context).setDark();
                                        }
                                      });
                                      break;
                                    case 1:
                                      _launchURL(appLink);

                                      break;
                                    case 2:
                                      FlutterShare.share(
                                          title: 'IPEC Student\'s App',
                                          text:
                                              'Best app for checking attendance and notices.',
                                          linkUrl: appLink,
                                          chooserTitle: 'IPEC');
                                      break;
                                    case 3:
                                      auth.logout().then((value) =>
                                          Navigator.pushReplacementNamed(
                                            context,
                                            SplashScreen.ROUTE,
                                          ));

                                      break;
                                  }
                                },
                                itemBuilder: _popOptions),
                          ],
                        ),
                        kHighPadding,
                        Text(
                          'Hello,',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  color: isDark ? Colors.white : Colors.black),
                        ),
                        Text(
                          auth.user!.name!,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                kHighPadding,
                                kHighPadding,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    optionIcon(
                                        'assets/icons/Bag.png',
                                        'Attendance',
                                        () => Navigator.pushNamed(
                                            context, AttendancePage.ROUTE)),
                                    optionIcon(
                                      'assets/icons/Atom.png',
                                      'Notices',
                                      () => Navigator.pushNamed(
                                          context, NoticesScreen.ROUTE),
                                    ),
                                  ],
                                ),
                                kMedPadding,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    optionIcon('assets/icons/conversation.png',
                                        'Cafeteria\nTalks', () {
                                      if (auth.user!.isFirstYear)
                                        _showSnackBar(
                                            "Sorry, First year students not allowed!");
                                      else {
                                        // auth.reloadHuser();
                                        Navigator.pushNamed(
                                            context, HangoutScreen.ROUTE);
                                      }
                                    }),
                                    optionIcon(
                                        'assets/icons/Compass.png', 'Marks',
                                        () {
                                      Navigator.pushNamed(
                                          context, SessionalMarksScreen.ROUTE);
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                            animation: animation,
                            builder: (BuildContext context, _) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.pushNamed(
                                        context, AboutScreen.ROUTE),
                                    borderRadius: BorderRadius.circular(30),
                                    highlightColor: kPrimaryLightColor,
                                    child: Ink(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              _rb[animation.value],
                                              _rb[(50.0 + animation.value) %
                                                  _rb.rangeEnd]
                                            ]),
                                        borderRadius: BorderRadius.circular(
                                            kMedCircleRadius),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.info_outline),
                                          kLowWidthPadding,
                                          Text(
                                            "Made by IPECians ❤️",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<PopupMenuEntry<int>> _popOptions(context) {
    var isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
    return [
      PopupMenuItem(
          value: 0,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                child: Icon(Icons.wb_sunny_rounded),
              ),
              Text(isDark ? 'Switch to light mode' : 'Switch to dark mode')
            ],
          )),
      PopupMenuItem(
          value: 1,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                child: Icon(Icons.star),
              ),
              Text('Rate')
            ],
          )),
      PopupMenuItem(
          value: 2,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                child: Icon(Icons.share),
              ),
              Text('Share')
            ],
          )),
      PopupMenuItem(
          value: 3,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                child: Icon(Icons.logout),
              ),
              Text('Logout')
            ],
          )),
    ];
  }

  Widget optionIcon(String img, String title, Function onPress) {
    return Flexible(
      child: InkWell(
        onTap: onPress as void Function()?,
        borderRadius: BorderRadius.circular(30),
        highlightColor: kPrimaryLightColor,
        child: Ink(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                img,
                width: SizeConfig.widthMultiplier * 15,
              ),
              kLowPadding,
              Text(
                title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String s) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(s)));
  }

  Future<void> reviewCheck() async {
    bool firstRun = await IsFirstRun.isFirstRun();
    if (firstRun) if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }
}
