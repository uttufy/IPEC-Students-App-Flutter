import '../../../../data/base_bloc/base_state.dart';
import '../../../../data/model/hangout/hangUser.dart';

class HangoutState extends BaseState {
  HangoutState([List props = const []]) : super(props);
}

class HangoutInitState extends HangoutState {}

class HangoutLoading extends HangoutState {}

class HangoutLoaded extends HangoutState {
  final Huser user;

  HangoutLoaded(this.user);
}

class SavedUserState extends HangoutState {
  final Huser user;

  SavedUserState(this.user);
}

class UserExistState extends HangoutState {}

class UserNotExistState extends HangoutState {}
