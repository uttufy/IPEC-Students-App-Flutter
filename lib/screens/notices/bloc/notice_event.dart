import '../../../data/base_bloc/base_event.dart';
import '../../../data/model/Notice.dart';
import '../../../data/repo/auth.dart';
import '../../../data/repo/session.dart';

class NoticeEvent extends BaseEvent {
  NoticeEvent([List props = const []]) : super(props);
}

class NoticeLoadEvent extends NoticeEvent {
  final Session session;
  final Auth auth;

  NoticeLoadEvent(this.session, this.auth);
}

class NoticeOpenEvent extends NoticeEvent {
  final Session session;
  final Auth auth;
  final Notice notice;

  NoticeOpenEvent(
    this.session,
    this.auth,
    this.notice,
  );
}
