import 'package:ipecstudents/data/base_bloc/base_bloc.dart';
import 'package:ipecstudents/data/base_bloc/base_event.dart';
import 'package:ipecstudents/data/base_bloc/base_state.dart';

import 'loading_event.dart';
import 'loading_state.dart';

class LoadingBloc extends BaseBloc {
  @override
  BaseState get initialState => LoadingInitState();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is CheckCredentials) {}
  }
}
