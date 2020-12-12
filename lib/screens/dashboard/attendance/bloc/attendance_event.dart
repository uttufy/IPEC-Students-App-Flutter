import 'package:ipecstudentsapp/data/base_bloc/base_event.dart';
import 'package:ipecstudentsapp/data/repo/auth.dart';
import 'package:ipecstudentsapp/data/repo/session.dart';

class AttendanceEvent extends BaseEvent {
  AttendanceEvent([List props = const []]) : super(props);
}

class LoadAttendance extends AttendanceEvent {
  final Auth auth;
  final Session session;
  LoadAttendance(this.auth, this.session);
}
