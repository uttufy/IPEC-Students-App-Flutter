import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../data/base_bloc/base_bloc_builder.dart';
import '../../data/base_bloc/base_bloc_listener.dart';
import '../../data/base_bloc/base_state.dart';
import '../../data/model/Notice.dart';
import '../../data/repo/auth.dart';
import '../../data/repo/session.dart';
import '../../theme/style.dart';
import '../../util/string_cap.dart';
import '../../widgets/simple_appbar.dart';
import 'bloc/notice_bloc.dart';
import 'bloc/notice_event.dart';
import 'bloc/notice_state.dart';
import 'pdf_viewer.dart';

class NoticesScreen extends StatefulWidget {
  static const String ROUTE = "/notices";
  @override
  _NoticesScreenState createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  final NoticeBloc _bloc = NoticeBloc();
  Auth _auth;
  List<Notice> _notices = [];

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

                if (state is NoticeOpeningLoading) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('⚡️ Loading in background!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                if (state is NoticeOpenFailedState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.msg),
                    ),
                  );
                }
                if (state is NoticeOpeningLoaded) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return PdfScreen(
                        url: state.url,
                        notice: state.notice,
                      );
                    },
                  ));
                }
              },
              child: BaseBlocBuilder(
                bloc: _bloc,
                condition: (BaseState previous, BaseState current) {
                  return true;
                },
                builder: (BuildContext context, BaseState state) {
                  print("$runtimeType BlocBuilder - ${state.toString()}");
                  if (state is NoticeInitial)
                    _bloc.add(NoticeLoadEvent(session, _auth));

                  return SafeArea(
                    child: Column(
                      children: [
                        SimpleAppBar(
                          onBack: () {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          },
                          title: "Notices",
                        ),
                        Visibility(
                            visible: state is NoticeOpeningLoading,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Text('⚡️ Loading...'),
                            )),
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

  Widget _getBody(Session session, BuildContext context, BaseState state) {
    if (state is NoticeLoadingState)
      return Center(
          child: CircularProgressIndicator(
        strokeWidth: 2,
        backgroundColor: Colors.black,
      ));
    if (state is NoticeLoadedState) {
      _notices = state.notices;
      return _noticesListView(_notices, session);
    }
    if (state is NoticeErrorState) return Center(child: Text(state.msg));
    if (state is NoticeInitial) return Center(child: Text("Intializing"));

    if (state is AllNoticeLoadedState) {
      _notices = state.notices;
      return _noticesListView(_notices, session);
    }

    if (state is NoticeOpeningLoaded ||
        state is NoticeOpeningLoading ||
        state is NoticeOpenFailedState)
      return _noticesListView(_notices, session);
    else
      return Center(child: Text("Something Went Wrong! Try Again"));
  }

  Widget _noticesListView(List<Notice> notices, Session session) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: notices?.length ?? 0,
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: _noticeItem(notices, index, session),
        );
      },
    );
  }

  Widget _noticeItem(List<Notice> notices, int index, Session session) {
    return NeumorphicButton(
      onPressed: () {
        // return _launchURL(notices[index].link);

        _bloc.add(NoticeOpenEvent(session, _auth, notices[index]));
      },
      padding: const EdgeInsets.all(20),
      style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
          depth: 8,
          lightSource: LightSource.top,
          color: notices[index].tp
              ? Colors.amberAccent.withOpacity(0.5)
              : Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notices[index].title,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          kLowPadding,
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date",
                      style: TextStyle(color: Colors.black26),
                    ),
                    Text(
                      notices[index].date,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Contri. by",
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.black26),
                    ),
                    Text(
                      notices[index].credit.toLowerCase().capitalize(),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
