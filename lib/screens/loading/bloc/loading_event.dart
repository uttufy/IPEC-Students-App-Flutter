import 'package:ipecstudents/data/base_bloc/base_event.dart';
import 'package:ipecstudents/data/model/Cred.dart';

class LoadingEvent extends BaseEvent {
  LoadingEvent([List props = const []]) : super(props);
}

class CheckCredentials extends LoadingEvent {
  final Cred cred;
  CheckCredentials(this.cred);
}

class ResetState extends LoadingEvent {}
