import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../data/base_bloc/base_bloc_builder.dart';
import '../../data/base_bloc/base_bloc_listener.dart';
import '../../data/base_bloc/base_state.dart';
import '../../data/model/Notice.dart';
import '../../data/repo/auth.dart';
import '../../data/repo/session.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';
import '../../util/string_cap.dart';
import '../../widgets/loading_widget.dart';
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
  final NoticeBloc _bloc = NoticeBloc(NoticeInitial());
  Auth? _auth;
  List<Notice> _notices = [];
  List<Notice> _duplicateNotices = [];

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
                if (state is NoticeLoadedState) {
                  _notices = state.notices;
                  _duplicateNotices.addAll(state.notices);
                }
                if (state is AllNoticeLoadedState) {
                  _notices = state.notices;
                  _duplicateNotices.clear();
                  _duplicateNotices.addAll(state.notices);
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

                  _bloc.add(NoticeScreenFinished(_notices));
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
    if (state is NoticeLoadedState) {
      // _notices = state.notices;

      return _noticesListView(session);
    }
    if (state is NoticeErrorState) return Center(child: Text(state.msg));
    if (state is NoticeInitial) return Center(child: Text("Intializing"));

    if (state is AllNoticeLoadedState) {
      return _noticesListView(session);
    }

    if (state is NoticeLoadingState ||
        state is NoticeOpeningLoaded ||
        state is NoticeOpeningLoading)
      return LoadingWidget();
    else if (state is NoticeOpenFailedState)
      return _noticesListView(session);
    else
      return Center(child: Text("Something Went Wrong! Try Again"));
  }

  void filterSearchResults(String query) {
    List<Notice> dummySearchList = [];
    dummySearchList.addAll(_notices);
    if (query.isNotEmpty) {
      List<Notice> dummyListData = [];

      dummySearchList.forEach((item) {
        if (item.title!.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _duplicateNotices.clear();
        _duplicateNotices.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _duplicateNotices.clear();
        _duplicateNotices.addAll(_notices);
      });
    }
  }

  Widget _noticesListView(Session session) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: CupertinoSearchTextField(
            style: Theme.of(context).textTheme.bodyLarge,
            onChanged: (String value) {
              print('The text has changed to: $value');
              filterSearchResults(value);
            },
            // onSubmitted: (String value) {
            //   print('Submitted text: $value');
            // },
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _duplicateNotices.length,
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: _noticeItem(_duplicateNotices, index, session),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _noticeItem(List<Notice> notices, int index, Session session) {
    final isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
    return NeumorphicButton(
      onPressed: () {
        _bloc.add(NoticeOpenEvent(session, _auth, notices[index]));
      },
      padding: const EdgeInsets.all(20),
      style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
          depth: isDark ? 5 : 8,
          lightSource: LightSource.top,
          shadowDarkColor: isDark ? Colors.black12 : null,
          shadowLightColor: isDark ? Colors.black45 : null,
          color: notices[index].tp!
              ? isDark
                  ? kOrange
                  : Colors.amberAccent.withOpacity(0.5)
              : isDark
                  ? kGrey
                  : Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notices[index].title!,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: isDark ? Colors.white : Colors.black,
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
                      style: TextStyle(
                          color: isDark ? Colors.white30 : Colors.black26),
                    ),
                    Text(
                      notices[index].date!,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(),
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
                      style: TextStyle(
                          color: isDark ? Colors.white30 : Colors.black26),
                    ),
                    Text(
                      notices[index].credit!.toLowerCase().capitalize(),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(),
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
