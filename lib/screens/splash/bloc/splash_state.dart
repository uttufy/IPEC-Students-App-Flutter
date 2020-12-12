import 'package:ipecstudentsapp/data/base_bloc/base_state.dart';

class SplashScreenState extends BaseState {
  SplashScreenState([List props = const []]) : super(props);
}

class SplashInitState extends SplashScreenState {}

class SplashLoaderState extends SplashScreenState {}

class OpenAuthenticationScreen extends SplashScreenState {}

class OpenDashboardScreen extends SplashScreenState {}

class NoZoneErrorState extends SplashScreenState {}
