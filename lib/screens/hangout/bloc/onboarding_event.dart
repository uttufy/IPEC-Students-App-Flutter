import 'package:ipecstudentsapp/data/base_bloc/base_event.dart';
import 'package:ipecstudentsapp/data/repo/auth.dart';
import 'package:ipecstudentsapp/data/repo/session.dart';

class OnboardingEvent extends BaseEvent {
  OnboardingEvent([List props = const []]) : super(props);
}

class LoadStudentData extends OnboardingEvent {
  final Auth auth;
  final Session session;
  LoadStudentData(this.auth, this.session);
}
