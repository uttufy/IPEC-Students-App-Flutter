import '../../../../data/base_bloc/base_state.dart';

class AttendanceState extends BaseState {
  AttendanceState([List props = const []]) : super(props);
}

class AttendanceInitState extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {}

class AttendanceFailed extends AttendanceState {}
