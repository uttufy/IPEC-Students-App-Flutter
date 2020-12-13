import 'package:ipecstudentsapp/data/base_bloc/base_event.dart';
import 'package:ipecstudentsapp/data/model/Notice.dart';
import 'package:ipecstudentsapp/data/repo/auth.dart';
import 'package:ipecstudentsapp/data/repo/session.dart';

class NoticeEvent extends BaseEvent {
  NoticeEvent([List props = const []]) : super(props);
}

class NoticeLoadEvent extends NoticeEvent {
  final Session session;
  final Auth auth;

  NoticeLoadEvent(this.session, this.auth);
}
