import 'package:flutter/material.dart';
import '../../data/base_bloc/base_bloc_builder.dart';
import '../../data/base_bloc/base_bloc_listener.dart';
import '../../data/base_bloc/base_state.dart';
import '../../data/repo/auth.dart';
import '../../data/repo/session.dart';
import 'bloc/sessional_bloc.dart';
import 'bloc/sessional_event.dart';
import 'bloc/sessional_state.dart';
import '../../theme/style.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/simple_appbar.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import 'package:webview_flutter/webview_flutter.dart';

class SessionalMarksScreen extends StatefulWidget {
  static const String ROUTE = "/sessional";
  const SessionalMarksScreen({Key? key}) : super(key: key);

  @override
  State<SessionalMarksScreen> createState() => _SessionalMarksScreenState();
}

class _SessionalMarksScreenState extends State<SessionalMarksScreen> {
  final SessionalBloc _bloc = SessionalBloc(SessionalInitial());
  Auth? _auth;

  @override
  void initState() {
    super.initState();
    _auth = Provider.of<Auth>(context, listen: false);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
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
                  if (state is SessionalInitial)
                    _bloc.add(SessionalLoadEvent(session, _auth));

                  return SafeArea(
                    child: Column(
                      children: [
                        SimpleAppBar(
                          onBack: () {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          },
                          title: "Marks",
                        ),
                        Expanded(
                          child: _getBody(session, context, state),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _getBody(session, BuildContext context, BaseState state) {
    if (state is SessionalErrorState)
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("😓🥴", style: TextStyle(fontSize: 100)),
          kMedPadding,
          Text(
            state.msg,
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
        ],
      );
    else if (state is SessionalLoadingState)
      return LoadingWidget();
    else if (state is AllSessionalLoadedState)
      return SafeArea(
        child: Platform.isMacOS || Platform.isWindows
            ? Center(child: Text("Sorry Not available on desktop"))
            : WebView(
                initialUrl:
                    Uri.dataFromString(state.data, mimeType: 'text/html')
                        .toString(),
                gestureNavigationEnabled: true,
              ),
      );
    else
      return Container();
  }
}
