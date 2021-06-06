import '../../../../data/base_bloc/base_event.dart';

class ChattersEvent extends BaseEvent {
  ChattersEvent([List props = const []]) : super(props);
}

class LoadChattersEvent extends ChattersEvent {
  final String postID;

  LoadChattersEvent(this.postID);
}
