import 'package:ipecstudentsapp/data/base_bloc/base_state.dart';
import 'package:ipecstudentsapp/data/model/Notice.dart';

class NoticeState extends BaseState {
  NoticeState([List props = const []]) : super(props);
}

class NoticeInitial extends NoticeState {}

class NoticeLoadingState extends NoticeState {}

class NoticeLoadedState extends NoticeState {
  final List<Notice> notices;
  NoticeLoadedState(this.notices);
}

class NoticeSyncedState extends NoticeState {}

class NoticeSyncingState extends NoticeState {}

class NoticeErrorState extends NoticeState {
  final msg;

  NoticeErrorState(this.msg);
}
