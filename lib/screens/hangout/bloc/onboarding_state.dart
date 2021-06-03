import 'package:ipecstudentsapp/data/base_bloc/base_state.dart';
import 'package:ipecstudentsapp/data/model/hangUser.dart';

class OnboardingState extends BaseState {
  OnboardingState([List props = const []]) : super(props);
}

class OnboardingInitState extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingLoaded extends OnboardingState {
  final Huser user;

  OnboardingLoaded(this.user);
}
