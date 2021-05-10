import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_bloc_builder.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_bloc_listener.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_state.dart';
import 'package:ipecstudentsapp/data/repo/auth.dart';
import 'package:ipecstudentsapp/data/repo/session.dart';
import 'package:ipecstudentsapp/screens/dashboard/attendance/bloc/attendance_bloc.dart';
import 'package:ipecstudentsapp/screens/dashboard/attendance/bloc/attendance_event.dart';
import 'package:ipecstudentsapp/screens/dashboard/attendance/bloc/attendance_state.dart';
import 'package:ipecstudentsapp/screens/dashboard/attendance/graph.dart';
import 'package:ipecstudentsapp/screens/dashboard/attendance/prediction_input_screen.dart';
import 'package:ipecstudentsapp/theme/colors.dart';
import 'package:ipecstudentsapp/theme/style.dart';
import 'package:ipecstudentsapp/util/SizeConfig.dart';
import 'package:ipecstudentsapp/widgets/general_dialog.dart';
import 'package:ipecstudentsapp/widgets/simple_appbar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AttendanceScreen extends StatefulWidget {
  static const String ROUTE = "/Attendance";
  final ScrollController scrollController;

  const AttendanceScreen({Key key, this.scrollController}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceBloc _bloc = AttendanceBloc();
  Auth _auth;
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
                  return _getBody(session, context, state);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _getBody(Session session, BuildContext context, BaseState state) {
    return SafeArea(
      child: SingleChildScrollView(
        controller: widget.scrollController,
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SimpleAppBar(
              img: _auth.user.img.toString().split(',')[1],
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
                        .headline6
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            kHighPadding,
            Text(
              'Total Attendance',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Colors.black,
                  ),
            ),
            kLowPadding,
            state is AttendanceLoaded
                ? Text(
                    session.attendance.percent < 0
                        ? "Failed"
                        : session.attendance.percent.toString() + "%",
                    style: Theme.of(context).textTheme.headline3.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w700),
                  )
                : Shimmer.fromColors(
                    baseColor: Colors.grey[400],
                    highlightColor: Colors.grey[200],
                    child: Text(
                      "00.0%",
                      style: Theme.of(context).textTheme.headline3.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    )),
            kLowPadding,
            state is AttendanceLoaded
                ? AttendanceGraph()
                : AspectRatio(
                    aspectRatio: 1.70,
                    child: Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.grey[200],
                        child: Container(
                          width: SizeConfig.screenWidth,
                          color: Colors.white,
                        )),
                  ),
            kMedPadding,
            state is AttendanceLoaded
                ? _bottomSlider(session)
                : AspectRatio(
                    aspectRatio: 3,
                    child: Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.grey[200],
                        child: Container(
                          width: SizeConfig.screenWidth,
                          color: Colors.white,
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
                    color: Colors.black),
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
                color: kPrimaryLightColor),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: _listitem(
                    iconBg: Colors.lightGreen[200],
                    img: 'assets/icons/skip.png',
                    main: 'Lectures Skipped',
                    title: session.attendance.percent < 0
                        ? "Failed"
                        : session.attendance
                                .getAbsentPercent()
                                .toStringAsFixed(0) +
                            "%",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: _listitem(
                    iconBg: Colors.orange[200],
                    img: 'assets/icons/attended.png',
                    main: 'Lectures Attended',
                    title:
                        session.attendance.presentLecture.split(": ")[1] ?? "",
                  ),
                ),
                _listitem(
                  iconBg: Colors.blue[200],
                  img: 'assets/icons/total.png',
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
      {@required String main,
      @required String title,
      Color iconBg = kPrimaryLightColor,
      Color cardBg = Colors.white,
      @required String img}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(30), color: cardBg),
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
                child: Image.asset(
                  img,
                  width: SizeConfig.widthMultiplier * 6,
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
