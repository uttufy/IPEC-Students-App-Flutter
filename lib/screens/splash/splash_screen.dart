import 'package:flutter/material.dart';
import 'package:ipecstudents/data/base_bloc/base_bloc_builder.dart';
import 'package:ipecstudents/data/base_bloc/base_bloc_listener.dart';
import 'package:ipecstudents/data/base_bloc/base_state.dart';
import 'package:ipecstudents/screens/login/login_screen.dart';
import 'package:ipecstudents/screens/splash/bloc/splash_bloc.dart';
import 'package:ipecstudents/screens/splash/bloc/splash_event.dart';
import 'package:ipecstudents/util/SizeConfig.dart';
import 'package:lottie/lottie.dart';

import 'bloc/splash_state.dart';

class SplashScreen extends StatefulWidget {
  static const String ROUTE = "/Splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashScreenBloc _bloc = SplashScreenBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseBlocListener(
        bloc: _bloc,
        listener: (BuildContext context, BaseState state) {
          print("$runtimeType BlocListener - ${state.toString()}");
          if (state is OpenAuthenticationScreen)
            Navigator.pushReplacementNamed(context, LoginScreen.ROUTE);
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
            if (state is SplashInitState) _bloc.add(CheckUserAuth());
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
