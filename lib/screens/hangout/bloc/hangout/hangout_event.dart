import 'package:ipecstudentsapp/data/repo/auth.dart';
import 'package:ipecstudentsapp/data/repo/session.dart';

import '../../../../data/base_bloc/base_event.dart';
import '../../../../data/model/User.dart';
import '../../../../data/model/hangout/hangUser.dart';

class HangoutEvent extends BaseEvent {
  HangoutEvent([List props = const []]) : super(props);
}

class LoadPingsEvent extends HangoutEvent {}

class OnboardFinishEvent extends HangoutEvent {
  final Huser? huser;

  OnboardFinishEvent(this.huser);
}

class CheckUserEvent extends HangoutEvent {
  final Auth auth;

  final Session session;
  CheckUserEvent(this.auth, this.session);
}
