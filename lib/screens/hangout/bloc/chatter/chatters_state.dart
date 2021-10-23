import 'package:ipecstudentsapp/data/base_bloc/base_state.dart';
import 'package:ipecstudentsapp/data/model/hangout/comment.dart';

class ChattersState extends BaseState {
  ChattersState([List props = const []]) : super(props);
}

class ChattersInitialState extends ChattersState {}

class ChattersLoadingState extends ChattersState {}

class ChattersLoadedState extends ChattersState {}

class ChattersErrorState extends ChattersState {}
