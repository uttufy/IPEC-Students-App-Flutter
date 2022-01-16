import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/base_bloc/base_bloc_builder.dart';
import '../../../data/base_bloc/base_bloc_listener.dart';
import '../../../data/base_bloc/base_state.dart';
import '../../../data/repo/auth.dart';
import '../../../data/repo/session.dart';
import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../../../util/SizeConfig.dart';
import '../../../widgets/general_dialog.dart';
import '../../../widgets/simple_appbar.dart';
import 'bloc/attendance_bloc.dart';
import 'bloc/attendance_event.dart';
import 'bloc/attendance_state.dart';
import 'graph.dart';
import 'prediction_input_screen.dart';

class AttendanceScreen extends StatefulWidget {
  static const String ROUTE = "/Attendance";
  final ScrollController? scrollController;

  const AttendanceScreen({Key? key, this.scrollController}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceBloc _bloc = AttendanceBloc(AttendanceInitState());
  Auth? _auth;
  @override
  void initState() {
    super.initState();
    _auth = Provider.of<Auth>(context, listen: false);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        body: Consumer<Session>(
          builder: (context, session, child) {
            return BaseBlocListener(
              bloc: _bloc,
              listener: (BuildContext context, BaseState state) {
                print("$runtimeType BlocListener - ${state.toString()}");
              },
              child: BaseBlocBuilder(
                bloc: _bloc,
                condition: (BaseState previous, BaseState current) {
                  return !(BaseBlocBuilder.isBaseState(current));
                },
                builder: (BuildContext context, BaseState state) {
                  print("$runtimeType BlocBuilder - ${state.toString()}");
                  if (state is AttendanceInitState)
                    _bloc.add(LoadAttendance(_auth, session));
                  if (state is AttendanceFailed)
                    return _attendanceLoadFailedBody(session, context);
                  else
                    return _getBody(session, context, state);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Column _attendanceLoadFailedBody(Session session, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: InkWell(
            onTap: () {
              _bloc.add(LoadAttendance(_auth, session));
            },
            borderRadius: BorderRadius.circular(30),
            highlightColor: kPrimaryLightColor,
            child: Ink(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: kBlue.withOpacity(0.5)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh_sharp,
                    size: 80,
                  ),
                  kLowPadding,
                  Text(
                    "Retry",
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(30),
            highlightColor: kPrimaryLightColor,
            child: Ink(
              padding: const EdgeInsets.all(20),
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(30),
              //     color: kGrey),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back_ios_new_outlined,
                    size: 50,
                  ),
                  kLowPadding,
                  Text(
                    "Go Back",
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getBody(Session session, BuildContext context, BaseState state) {
    bool isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
    return SafeArea(
      child: SingleChildScrollView(
        controller: widget.scrollController,
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SimpleAppBar(
              img: _auth!.user!.img.toString().split(',')[1],
              onPic: () {
                if (state is AttendanceLoaded) {
                  GeneralDialog.show(
                    context,
                    title: "Message",
                    message: session.attendance.getAttendanceMessage(),
                  );
                }
              },
              onBack: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
            kLowPadding,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: [
                  Text(
                    'Overview',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            kHighPadding,
            Text(
              'Total Attendance',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                  ),
            ),
            kLowPadding,
            state is AttendanceLoaded
                ? Text(
                    session.attendance.percent < 0
                        ? "Failed"
                        : session.attendance.percent.toString() + "%",
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w700),
                  )
                : Shimmer.fromColors(
                    baseColor: Colors.grey[400]!,
                    highlightColor: Colors.grey[200]!,
                    child: Text(
                      "00.0%",
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    )),
            kLowPadding,
            state is AttendanceLoaded
                ? AttendanceGraph()
                : AspectRatio(
                    aspectRatio: 1.70,
                    child: Shimmer.fromColors(
                        baseColor: isDark ? kDarkBg : Colors.white,
                        highlightColor:
                            isDark ? Colors.grey[900]! : Colors.grey[200]!,
                        child: Container(
                          width: SizeConfig.screenWidth,
                          color: isDark ? kDarkBg : Colors.white,
                        )),
                  ),
            kMedPadding,
            state is AttendanceLoaded
                ? _bottomSlider(session)
                : AspectRatio(
                    aspectRatio: 3,
                    child: Shimmer.fromColors(
                        baseColor: isDark ? kDarkBg : Colors.white,
                        highlightColor:
                            isDark ? Colors.grey[900]! : Colors.grey[200]!,
                        child: Container(
                          width: SizeConfig.screenWidth,
                          color: isDark ? kDarkBg : Colors.white,
                        )),
                  ),
            state is AttendanceLoaded
                ? Text("↓ Pull down to show table")
                : SizedBox(),
            kHighPadding,
          ],
        ),
      ),
    );
  }

  SingleChildScrollView _bottomSlider(Session session) {
    bool isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: InkWell(
              onTap: () {
                if (session.attendance.percent > 0)
                  Navigator.pushNamed(context, PredictionInputScreen.ROUTE,
                      arguments: {'attendance': session.attendance});
                else
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Predict attendance is not available at this moment!")));
              },
              borderRadius: BorderRadius.circular(30),
              child: Ink(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: isDark ? kGreen : Colors.black),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Lottie.asset('assets/anim/bulb.json',
                        width: SizeConfig.widthMultiplier * 20),
                    kMedPadding,
                    Text(
                      'Predict Attendance',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: isDark
                    ? kPrimaryLightColor.withOpacity(0.1)
                    : kPrimaryLightColor),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: _listitem(
                      isDark: isDark,
                      iconBg: Colors.blue[200],
                      emoji: '🏄',
                      main: 'Extra Attendance',
                      title: session.attendance.extra.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: _listitem(
                      isDark: isDark,
                      iconBg: Colors.cyan[200],
                      emoji: '🎖',
                      main: 'Attended Sessional',
                      title: session.attendance.sessionalPresent.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: _listitem(
                      isDark: isDark,
                      iconBg: Colors.purple[200],
                      emoji: '⏰',
                      main: 'Total Sessional',
                      title: session.attendance.sessionalTotal.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: _listitem(
                      isDark: isDark,
                      iconBg: Colors.red[200],
                      emoji: '🏝',
                      main: 'Present SIP',
                      title: session.attendance.sipPresentClasses.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: _listitem(
                      isDark: isDark,
                      iconBg: Colors.yellow[200],
                      emoji: '🗽',
                      main: 'Total SIP Classes',
                      title: session.attendance.sipTotalClasses.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: _listitem(
                      isDark: isDark,
                      iconBg: Colors.green[200],
                      emoji: '✍🏄',
                      main: 'Attendend Lectures + Extra',
                      title: session.attendance.cummulativeTotalLectures
                          .toString()),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: _listitem(
                    isDark: isDark,
                    iconBg: Colors.lightBlue[200],
                    emoji: '✍',
                    main: 'Lectures Attended',
                    title: session.attendance.presentLecture ?? "",
                  ),
                ),
                _listitem(
                  isDark: isDark,
                  iconBg: Colors.deepPurple[200],
                  emoji: '🙋',
                  main: 'Total Lectures',
                  title: session.attendance.getTotalLectures().toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _listitem(
      {required String main,
      required String title,
      Color? iconBg = kPrimaryLightColor,
      Color cardBg = Colors.white,
      required String emoji,
      required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isDark ? kDarkBg : cardBg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: iconBg),
                child: Text(
                  emoji,
                  style: TextStyle(fontSize: SizeConfig.textMultiplier * 6),
                ),
              ),
              kMedWidthPadding,
              Text(
                title,
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
          kMedPadding,
          Text(
            main,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
