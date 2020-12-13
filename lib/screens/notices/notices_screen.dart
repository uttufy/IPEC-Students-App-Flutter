import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_bloc_builder.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_bloc_listener.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_state.dart';
import 'package:ipecstudentsapp/data/repo/session.dart';
import 'package:ipecstudentsapp/screens/notices/bloc/notice_event.dart';
import 'package:ipecstudentsapp/widgets/simple_appbar.dart';
import 'package:provider/provider.dart';

import 'bloc/notice_bloc.dart';
import 'bloc/notice_state.dart';

class NoticesScreen extends StatefulWidget {
  static const String ROUTE = "/notices";
  @override
  _NoticesScreenState createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  final NoticeBloc _bloc = NoticeBloc();
  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Session>(
        builder: (context, session, child) {
          return BaseBlocListener(
            bloc: _bloc,
            listener: (BuildContext context, BaseState state) {
              print("$runtimeType BlocListener - ${state.toString()}");
            },
            child: BaseBlocBuilder(
              bloc: _bloc,
              condition: (BaseState previous, BaseState current) {
                return true;
              },
              builder: (BuildContext context, BaseState state) {
                print("$runtimeType BlocBuilder - ${state.toString()}");
                if (state is NoticeInitial) _bloc.add(NoticeLoadEvent());
                return SafeArea(
                  child: Column(
                    children: [
                      SimpleAppBar(
                        onBack: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        title: "Notices",
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _getBody(session, context, state),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _getBody(Session session, BuildContext context, BaseState state) {
    print(state.toString() + "asdsadsadsa");
    if (state is NoticeLoadingState)
      return Center(child: CircularProgressIndicator());
    else if (state is NoticeLoadedState)
      return Text("Asdsd");
    else if (state is NoticeErrorState)
      return Text(state.msg);
    else if (state is NoticeInitial)
      return Text("Intializing");
    else
      return Text("Something Went Wrong! Try Again");
  }
}
