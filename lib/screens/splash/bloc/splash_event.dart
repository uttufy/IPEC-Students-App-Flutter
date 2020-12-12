import 'package:ipecstudentsapp/data/base_bloc/base_event.dart';
import 'package:ipecstudentsapp/data/repo/auth.dart';

class SplashScreenEvent extends BaseEvent {
  SplashScreenEvent([List props = const []]) : super(props);
}

class CheckUserAuth extends SplashScreenEvent {
  final Auth auth;
  CheckUserAuth(this.auth);
}
