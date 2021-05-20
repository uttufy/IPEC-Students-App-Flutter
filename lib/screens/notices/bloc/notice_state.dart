import '../../../data/base_bloc/base_state.dart';
import '../../../data/model/Notice.dart';

class NoticeState extends BaseState {
  NoticeState([List props = const []]) : super(props);
}

class NoticeInitial extends NoticeState {}

class NoticeLoadingState extends NoticeState {}

class NoticeLoadedState extends NoticeState {
  final List<Notice> notices;
  NoticeLoadedState(this.notices);
}

class AllNoticeLoadedState extends NoticeState {
  final List<Notice> notices;
  AllNoticeLoadedState(this.notices);
}

class NoticeErrorState extends NoticeState {
  final msg;

  NoticeErrorState(this.msg);
}

class NoticeOpenFailedState extends NoticeState {
  final msg;

  NoticeOpenFailedState(this.msg);
}

class NoticeOpeningLoading extends NoticeState {}

class NoticeOpeningLoaded extends NoticeState {
  final String url;
  final Notice notice;
  NoticeOpeningLoaded(this.url, this.notice);
}
