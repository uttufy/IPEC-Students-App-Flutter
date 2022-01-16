import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_bloc.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_event.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_state.dart';
import 'package:ipecstudentsapp/data/model/hangout/comment.dart';
import 'chatters_state.dart';
import 'chatters_event.dart';

class ChattersBloc extends BaseBloc {
  ChattersBloc(BaseState initialState) : super(initialState);

  @override
  BaseState get initialState => ChattersInitialState();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    final firebaseRef =
        FirebaseDatabase.instance.reference().child('hangout/comments');
    if (event is LoadChattersEvent) {
      yield ChattersLoadingState();

      try {
        final res = await firebaseRef.child(event.postID!).once();

        List<CommentModel> _list = [];
        if (res != null && res.value != null && res.value.keys != null) {
          var keys = res.value.keys;
          var data = res.value;
          for (var indivisualKey in keys) {
            _list.add(CommentModel.fromSnapshot(data, indivisualKey));
          }
        }
        event.pings.comments[event.postID] = _list;
        yield ChattersLoadedState();
      } catch (e) {
        yield ShowDialogErrorState(e.toString());
      }
    }
  }
}
