import '../../../../data/base_bloc/base_event.dart';
import '../../../../data/repo/auth.dart';
import '../../../../data/repo/session.dart';

class AttendanceEvent extends BaseEvent {
  AttendanceEvent([List props = const []]) : super(props);
}

class LoadAttendance extends AttendanceEvent {
  final Auth auth;
  final Session session;
  LoadAttendance(this.auth, this.session);
}
