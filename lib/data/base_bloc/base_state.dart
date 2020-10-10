import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
 final List props;
  BaseState([this.props = const []]);

  @override
  String toString() => "$runtimeType";
}

class ShowSnackBarErrorState extends BaseState {
  final String error;
  ShowSnackBarErrorState(this.error) : super([error]);
}

class ShowDialogInfoState extends BaseState {
  final String title;
  final String message;
  ShowDialogInfoState(this.title,this.message) : super([title,message]);
}

class ShowDialogErrorState extends BaseState {
  final String error;
  ShowDialogErrorState(this.error) : super([error]);
}

class ShowProgressLoader extends BaseState{
  final String message;
  ShowProgressLoader(this.message) : super([message]);
}

class PlaceHolderState extends BaseState {
}


class LogoutState extends BaseState{
  
}
