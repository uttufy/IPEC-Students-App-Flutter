import 'package:ipecstudents/data/base_bloc/base_event.dart';

class LoadingEvent extends BaseEvent {
  LoadingEvent([List props = const []]) : super(props);
}

class CheckCredentials extends LoadingEvent {}

class ResetState extends LoadingEvent {}
