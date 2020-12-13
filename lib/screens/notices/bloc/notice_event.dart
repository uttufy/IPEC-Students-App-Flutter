import 'package:ipecstudentsapp/data/base_bloc/base_event.dart';

class NoticeEvent extends BaseEvent {
  NoticeEvent([List props = const []]) : super(props);
}

class NoticeLoadEvent extends NoticeEvent {}
