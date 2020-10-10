import 'package:flutter/material.dart';
import 'package:ipecstudents/data/base_bloc/base_bloc_builder.dart';
import 'package:ipecstudents/data/base_bloc/base_bloc_listener.dart';
import 'package:ipecstudents/data/base_bloc/base_state.dart';
import 'package:ipecstudents/screens/loading/bloc/loading_bloc.dart';
import 'package:ipecstudents/screens/loading/bloc/loading_event.dart';
import 'package:ipecstudents/screens/loading/bloc/loading_state.dart';
import 'package:ipecstudents/theme/colors.dart';
import 'package:ipecstudents/widgets/background.dart';
import 'package:lottie/lottie.dart';
import 'package:mantras/mantras.dart';

class LoadingScreen extends StatelessWidget {
  static const String ROUTE = "/Loading";
  final LoadingBloc _bloc = LoadingBloc();
  // Retrieve single mantra
  String mantra = Mantras().getMantra();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BaseBlocListener(
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
            if (state is LoadingInitState) _bloc.add(CheckCredentials());
            return _getBody(context, size);
          },
        ),
      ),
    );
  }

  Background _getBody(BuildContext context, Size size) {
    return Background(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'Loading',
            style: Theme.of(context)
                .primaryTextTheme
                .headline5
                .copyWith(color: Colors.black, fontWeight: FontWeight.w700),
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
