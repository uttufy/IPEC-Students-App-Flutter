import '../../../../data/base_bloc/base_event.dart';
import '../../../../data/model/hangout/hangUser.dart';
import '../../../../data/repo/auth.dart';
import '../../../../data/repo/session.dart';

class OnboardingEvent extends BaseEvent {
  OnboardingEvent([List props = const []]) : super(props);
}

class LoadStudentData extends OnboardingEvent {
  final Auth? auth;
  final Session session;
  LoadStudentData(this.auth, this.session);
}

class SaveStudentDataEvent extends OnboardingEvent {
  final Huser user;

  SaveStudentDataEvent(this.user);
}
