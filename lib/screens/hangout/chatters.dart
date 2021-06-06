import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_bloc_builder.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_bloc_listener.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_state.dart';
import 'package:ipecstudentsapp/screens/hangout/bloc/chatter/chatters_bloc.dart';

import 'bloc/chatter/chatters_bloc.dart';
import 'bloc/chatter/chatters_event.dart';
import 'bloc/chatter/chatters_state.dart';

class Chatters extends StatefulWidget {
  final String postID;
  const Chatters({Key key, @required this.postID}) : super(key: key);

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
            _bloc.add(LoadChattersEvent(widget.postID));
          return Container();
        },
      ),
    );
  }
}
