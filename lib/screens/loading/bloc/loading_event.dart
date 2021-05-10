import '../../../data/base_bloc/base_event.dart';

import '../../../data/repo/auth.dart';

class LoadingEvent extends BaseEvent {
  LoadingEvent([List props = const []]) : super(props);
}

class CheckCredentials extends LoadingEvent {
  final Auth auth;
  CheckCredentials(this.auth);
}

class ResetState extends LoadingEvent {}
