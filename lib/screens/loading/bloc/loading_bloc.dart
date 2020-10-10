import 'package:ipecstudents/data/base_bloc/base_bloc.dart';
import 'package:ipecstudents/data/base_bloc/base_event.dart';
import 'package:ipecstudents/data/base_bloc/base_state.dart';
import 'package:ipecstudents/data/repo/auth.dart';

import 'loading_event.dart';
import 'loading_state.dart';

class LoadingBloc extends BaseBloc {
  @override
  BaseState get initialState => LoadingInitState();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is CheckCredentials) {
      try {
        await Auth().login('username', 'password');
      } on Exception catch (e) {
        yield ShowDialogErrorState(e?.toString() ?? "Fatal Error");
      }
    }
  }
}
