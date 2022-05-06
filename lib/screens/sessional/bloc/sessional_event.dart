import '../../../data/base_bloc/base_event.dart';
import '../../../data/repo/auth.dart';
import '../../../data/repo/session.dart';

class SessionalEvent extends BaseEvent {
  SessionalEvent([List props = const []]) : super(props);
}

class SessionalLoadEvent extends SessionalEvent {
  final Session session;
  final Auth? auth;

  SessionalLoadEvent(this.session, this.auth);
}

class SessionalLoadingFinished extends SessionalEvent {}
