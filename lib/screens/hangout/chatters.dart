import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_bloc_builder.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_bloc_listener.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_state.dart';
import 'package:ipecstudentsapp/data/model/hangout/comment.dart';
import 'package:ipecstudentsapp/data/repo/pings.dart';
import 'package:ipecstudentsapp/screens/hangout/bloc/chatter/chatters_bloc.dart';
import 'package:ipecstudentsapp/screens/hangout/widget/comment_widget.dart';
import 'package:provider/provider.dart';
import 'bloc/chatter/chatters_bloc.dart';
import 'bloc/chatter/chatters_event.dart';
import 'bloc/chatter/chatters_state.dart';

class Chatters extends StatefulWidget {
  final String postID;
  final String currentUserID;
  const Chatters({Key key, @required this.postID, @required this.currentUserID})
      : super(key: key);

  @override
  _ChattersState createState() => _ChattersState();
}

class _ChattersState extends State<Chatters> {
  final _bloc = ChattersBloc();

  @override
  void dispose() {
    _bloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Pings>(
      builder: (context, pings, child) {
        return BaseBlocListener(
          bloc: _bloc,
          listener: (BuildContext context, BaseState state) {
            print("$runtimeType BlocListener - ${state.toString()}");
          },
          child: BaseBlocBuilder(
            bloc: _bloc,
            condition: (BaseState previous, BaseState current) {
              return !(BaseBlocBuilder.isBaseState(current));
            },
            builder: (BuildContext context, BaseState state) {
              print("$runtimeType BlocBuilder - ${state.toString()}");

              if (state is ChattersInitialState)
                _bloc.add(LoadChattersEvent(widget.postID, pings));

              if (state is ChattersLoadingState)
                return Center(child: CircularProgressIndicator());

              if (state is ChattersLoadedState)
                return _getBody(pings.comments[widget.postID]);
              return Container();
            },
          ),
        );
      },
    );
  }

  Widget _getBody(List<CommentModel> comments) {
    if (comments == null || comments.length == 0)
      return Container(
        padding: const EdgeInsets.all(20),
        child: Text("be the first one to chatter 😊 "),
      );
    else
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: comments.length ?? 0,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: CommentWidget(
              commentModel: comments[index],
              currentUserID: widget.currentUserID,
            ),
          );
        },
      );
  }
}
