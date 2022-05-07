import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../data/base_bloc/base_bloc_builder.dart';
import '../../data/base_bloc/base_bloc_listener.dart';
import '../../data/base_bloc/base_state.dart';
import '../../data/repo/auth.dart';
import '../../util/SizeConfig.dart';
import '../loading/loading_screen.dart';
import '../login/login_screen.dart';
import 'bloc/splash_bloc.dart';
import 'bloc/splash_event.dart';
import 'bloc/splash_state.dart';

class SplashScreen extends StatefulWidget {
  static const String ROUTE = "/Splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashScreenBloc _bloc = SplashScreenBloc(SplashInitState());

  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  Future<void> initFirebase() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     // _showItemDialog(message);
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     // _navigateToItemDetail(message);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     // _navigateToItemDetail(message);
    //   },
    // );
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    _firebaseMessaging.subscribeToTopic("GeneralNotices");
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseBlocListener(
        bloc: _bloc,
        listener: (BuildContext context, BaseState state) {
          print("$runtimeType BlocListener - ${state.toString()}");
          if (state is OpenAuthenticationScreen)
            Navigator.pushReplacementNamed(context, LoginScreen.ROUTE);

          if (state is OpenDashboardScreen)
            Navigator.pushReplacementNamed(context, LoadingScreen.ROUTE,
                arguments: {'isFirstLogin': false});
          // if (state is OpenHomeScreenState)
          //   Navigator.pushReplacementNamed(context, HomePage.ROUTE);
        },
        child: BaseBlocBuilder(
          bloc: _bloc,
          condition: (BaseState previous, BaseState current) {
            return !(BaseBlocBuilder.isBaseState(current));
          },
          builder: (BuildContext context, BaseState state) {
            print("$runtimeType BlocBuilder - ${state.toString()}");
            if (state is SplashInitState)
              _bloc.add(
                  CheckUserAuth(Provider.of<Auth>(context, listen: false)));
            return _getBody();
          },
        ),
      ),
    );
  }
}

Widget _getBody() {
  return SafeArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Image(
          height: SizeConfig.heightMultiplier * 20,
          image: AssetImage('assets/images/logo.png'),
        ),
        Spacer(),
        Lottie.asset('assets/anim/loading.json',
            height: SizeConfig.heightMultiplier * 20),
        Spacer(),
      ],
    ),
  );
}
