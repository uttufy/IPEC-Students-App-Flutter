import 'package:ipecstudentsapp/data/base_bloc/base_state.dart';

class LoadingState extends BaseState {
  LoadingState([List props = const []]) : super(props);
}

class LoadingInitState extends LoadingState {}

class CloseLoadingState extends LoadingState {}

class LoginFailState extends LoadingState {}

class AuthenticatedState extends LoadingState {}
