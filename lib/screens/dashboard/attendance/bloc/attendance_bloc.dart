import 'package:html/parser.dart';
import 'package:ipecstudents/data/base_bloc/base_bloc.dart';
import 'package:ipecstudents/data/base_bloc/base_event.dart';
import 'package:ipecstudents/data/base_bloc/base_state.dart';
import 'package:ipecstudents/data/model/GeneralResponse.dart';
import 'package:ipecstudents/data/model/TokensModel.dart';
import 'package:ipecstudents/screens/dashboard/attendance/bloc/attendance_event.dart';

import 'attendance_state.dart';

class AttendanceBloc extends BaseBloc {
  @override
  BaseState get initialState => AttendanceInitState();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadAttendance) {
      yield AttendanceLoading();
      try {
        GeneralResponse response =
            await event.session.webClientService.getAttendanceToken(
          event.auth.cred,
          event.auth.token,
        );
        if (response.status) {
          Tokens _tokens = Tokens();
          //  Step 2: parse Tokens
          var document = parse(response.data.data);

          _tokens.viewState =
              document.querySelector('#__VIEWSTATE').attributes['value'];
          _tokens.viewStateGenerator = document
              .querySelector('#__VIEWSTATEGENERATOR')
              .attributes['value'];
          _tokens.eventValidation =
              document.querySelector('#__EVENTVALIDATION').attributes['value'];
          if (_tokens.viewState != null &&
              _tokens.viewStateGenerator != null &&
              _tokens.eventValidation != null) {
            Map<String, String> body = {
              '__VIEWSTATE': _tokens.viewState,
              '__VIEWSTATEGENERATOR': _tokens.viewStateGenerator,
              '__EVENTVALIDATION': _tokens.eventValidation,
              "ctl00\$ContentPlaceHolder1\$txtstudent":
                  event.auth.cred.username,
              "ctl00\$ContentPlaceHolder1\$btnview": "view"
            };
            GeneralResponse postResponse = await event.session.webClientService
                .postAttendance(event.auth.cred, event.auth.token, body);
            if (postResponse.status) {
              // parse attendance

              event.session.setAttendance(postResponse.data.data);
              yield AttendanceLoaded();
            } else
              throw Exception(postResponse.error);
          } else
            throw Exception(
                "Failed to load attendance! Error at parsing tokens");
        } else {
          yield ShowDialogErrorState(response.error);
        }
      } on Exception catch (e) {
        yield ShowDialogErrorState(e.toString());
      }
    }
  }
}
