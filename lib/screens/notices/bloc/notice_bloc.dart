import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_bloc.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_event.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_state.dart';
import 'package:ipecstudentsapp/data/model/GeneralResponse.dart';
import 'package:ipecstudentsapp/data/model/Notice.dart';

import 'package:ipecstudentsapp/screens/notices/bloc/notice_state.dart';

import 'notice_event.dart';

class NoticeBloc extends BaseBloc {
  @override
  BaseState get initialState => NoticeInitial();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is NoticeLoadEvent) {
      yield NoticeLoadingState();
      GeneralResponse response = await event.session.webClientService
          .getNotices(event.auth.token.cookies);

      if (response.status) {
        var document = parse(response.data);
        String element = document
            .querySelector("#ContentPlaceHolder1_gridViewNotices")
            .outerHtml;
        if (element == null)
          yield NoticeErrorState("Error: Parsing Notices Failed");
        else {
          Document table = parse(element);
          var rows = table.querySelectorAll('tr');
          if (rows != null) {
            var query1 =
                "#ContentPlaceHolder1_gridViewNotices_gridViewNotices_grdlblHeading_";
            var query2 =
                "#ContentPlaceHolder1_gridViewNotices_gridViewNotices_gridlblPostedDate_";
            var query3 =
                "#ContentPlaceHolder1_gridViewNotices_gridViewNotices_hlpkView_";
            String link;
            var date;
            bool tp = false;
            DateFormat format = new DateFormat("dd MMM yyyy HH:mm:ss");
            List<Notice> notices = [];
            for (int i = 0; i < 10; i++) {
              tp = false;
              element = table.querySelector(query1 + i.toString()).text;
              date = table.querySelector(query2 + i.toString()).text;
              link = table.querySelector(query3 + i.toString()).text;
              if (element.contains('T & P')) {
                tp = true;
              }
              notices.add(Notice(
                  title: element,
                  date: date,
                  link: link,
                  credit: event.auth.user.name,
                  tp: tp));
              yield NoticeLoadedState(notices);
            }
          }

          //End of else statement
        }
      }
      if (event is NoticeSyncEvent) {
        yield NoticeSyncingState();
      }
    }
  }
}
