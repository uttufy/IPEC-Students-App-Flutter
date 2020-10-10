import 'package:equatable/equatable.dart';

abstract class BaseEvent extends Equatable {
  final List props;
  BaseEvent([this.props = const []]);

  @override
  String toString() => "$runtimeType";
}

class ShowSnackBarErrorEvent extends BaseEvent {
  final String error;

  ShowSnackBarErrorEvent(this.error) : super([error]);
}
class ShowProgressLoaderEvent extends BaseEvent {
  final String message;

  ShowProgressLoaderEvent(this.message) : super([message]);
}

class ShowDialogErrorEvent extends BaseEvent {
  final String error;

  ShowDialogErrorEvent(this.error) : super([error]);
}

class ShowDialogInfoEvent extends BaseEvent {

  final String title;
  final String message;

  ShowDialogInfoEvent(
   this.title, this.message) :super([title,message]);
}

class PlaceHolderEvent extends BaseEvent {
}

class ShowSessionOutDialogEvent extends BaseEvent {
}

class InitStateEvent extends BaseEvent {
}

class LogoutEvent extends BaseEvent {
}
