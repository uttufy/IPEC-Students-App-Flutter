import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mantras/mantras.dart';
import 'package:provider/provider.dart';

import '../../data/base_bloc/base_bloc_builder.dart';
import '../../data/base_bloc/base_bloc_listener.dart';
import '../../data/base_bloc/base_state.dart';
import '../../data/repo/auth.dart';
import '../../theme/colors.dart';
import '../../widgets/background.dart';
import '../dashboard/dashboard_page.dart';
import '../login/login_screen.dart';
import 'bloc/loading_bloc.dart';
import 'bloc/loading_event.dart';
import 'bloc/loading_state.dart';

class LoadingScreen extends StatefulWidget {
  static const String ROUTE = "/Loading";

  final bool isFirstLogin;

  const LoadingScreen({Key key, this.isFirstLogin}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final LoadingBloc _bloc = LoadingBloc();
  String mantra = Mantras().getMantra();

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BaseBlocListener(
        bloc: _bloc,
        listener: (BuildContext context, BaseState state) {
          print("$runtimeType BlocListener - ${state.toString()}");
          if (state is CloseLoadingState) {
            if (widget.isFirstLogin)
              Navigator.pop(context);
            else
              Navigator.pushReplacementNamed(context, LoginScreen.ROUTE);
          }

          if (state is AuthenticatedState) {
            Navigator.pushNamedAndRemoveUntil(
                context, DashboardScreen.ROUTE, (route) => false);
          }
        },
        child: BaseBlocBuilder(
          bloc: _bloc,
          condition: (BaseState previous, BaseState current) {
            // return !(BaseBlocBuilder.isBaseState(current));
            return true;
          },
          builder: (BuildContext context, BaseState state) {
            print("$runtimeType BlocBuilder - ${state.toString()}");
            if (state is LoadingInitState)
              _bloc.add(
                  CheckCredentials(Provider.of<Auth>(context, listen: false)));

            return _getBody(context, size, state);
          },
        ),
      ),
    );
  }

  Background _getBody(BuildContext context, Size size, BaseState state) {
    final isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
    return Background(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            state is LoginFailState ? 'Please Try Again' : 'Loading',
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.headline5.copyWith(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.w700),
          ),
          Lottie.asset('assets/anim/loading2.json'),
          Positioned(
            bottom: 0,
            child: Container(
              width: size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Mantra : " + mantra,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                      color: kGrey,
                    ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
