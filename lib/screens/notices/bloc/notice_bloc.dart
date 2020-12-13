import 'package:ipecstudentsapp/data/base_bloc/base_bloc.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_event.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_state.dart';

import 'package:ipecstudentsapp/screens/notices/bloc/notice_state.dart';

import 'notice_event.dart';

class NoticeBloc extends BaseBloc {
  @override
  BaseState get initialState => NoticeInitial();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is NoticeLoadEvent) yield NoticeLoadingState();
  }
}
