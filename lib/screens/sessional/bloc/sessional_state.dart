import '../../../data/base_bloc/base_state.dart';

class SessionalState extends BaseState {
  SessionalState([List props = const []]) : super(props);
}

class SessionalInitial extends SessionalState {}

class SessionalLoadingState extends SessionalState {}

class AllSessionalLoadedState extends SessionalState {
  final String data;
  AllSessionalLoadedState(this.data);
}

class SessionalErrorState extends SessionalState {
  final msg;

  SessionalErrorState(this.msg);
}

class SessionalOpenFailedState extends SessionalState {
  final msg;

  SessionalOpenFailedState(this.msg);
}

class SessionalOpeningLoading extends SessionalState {}

class SessionalOpeningLoaded extends SessionalState {}
