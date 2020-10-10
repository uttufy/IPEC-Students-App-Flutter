import 'package:ipecstudents/data/base_bloc/base_bloc.dart';
import 'package:ipecstudents/data/base_bloc/base_event.dart';
import 'package:ipecstudents/data/base_bloc/base_state.dart';
import 'package:ipecstudents/screens/splash/bloc/splash_state.dart';

import 'splash_event.dart';

class SplashScreenBloc extends BaseBloc {
  @override
  BaseState get initialState => SplashInitState();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {}
}
