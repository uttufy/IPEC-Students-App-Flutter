import 'package:flutter/material.dart';
import '../../data/base_bloc/base_bloc_builder.dart';
import '../../data/base_bloc/base_bloc_listener.dart';
import '../../data/base_bloc/base_state.dart';
import '../../data/repo/auth.dart';
import 'bloc/hangout/hangout_bloc.dart';
import 'bloc/hangout/hangout_event.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/simple_appbar.dart';
import 'package:provider/provider.dart';

import 'bloc/hangout/hangout_state.dart';
import 'feed.dart';
import 'onboarding.dart';

class HangoutScreen extends StatefulWidget {
  static const String ROUTE = "/hangout";
  @override
  _HangoutScreenState createState() => _HangoutScreenState();
}

class _HangoutScreenState extends State<HangoutScreen> {
  final _bloc = HangoutBloc();
  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, child) {
        return Scaffold(
            body: SafeArea(
          child: Column(
            children: [
              SimpleAppBar(
                onBack: () => Navigator.pop(context),
                title: 'Cafeteria Talks',
              ),
              BaseBlocListener(
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

                    if (state is HangoutInitState) {
                      _bloc.add(CheckUserEvent(auth.user));
                    }
                    if (state is HangoutLoading) return LoadingWidget();
                    if (state is UserNotExistState)
                      return _getOnboardingBody(auth);
                    if (state is UserExistState) return HangoutFeedScreen();
                    return Center(
                      child: Text("Something went wrong try again!"),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
      },
    );
  }

  Widget _getOnboardingBody(Auth auth) {
    return Expanded(
        child: Onboarding(
      auth: auth,
      onDone: () {
        _bloc.add(OnboardFinishEvent());
      },
    ));
  }
}
