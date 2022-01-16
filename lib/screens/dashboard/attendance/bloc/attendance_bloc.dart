import 'package:dio/dio.dart';
import 'package:html/parser.dart';

import '../../../../data/base_bloc/base_bloc.dart';
import '../../../../data/base_bloc/base_event.dart';
import '../../../../data/base_bloc/base_state.dart';
import '../../../../data/model/GeneralResponse.dart';
import '../../../../data/model/TokensModel.dart';
import '../../../../data/repo/session.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends BaseBloc {
  AttendanceBloc(BaseState initialState) : super(initialState);

  @override
  BaseState get initialState => AttendanceInitState();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadAttendance) {
      yield AttendanceLoading();
      event.session.setStatus(AttendanceStatus.Loading);
      try {
        GeneralResponse response =
            await event.session.webClientService.getAttendanceToken(
          event.auth!.cred,
          event.auth!.token,
        );
        if (response.status) {
          Tokens _tokens = Tokens();
          //  Step 2: parse Tokens
          var document = parse(response.data.data);

          _tokens.viewState =
              document.querySelector('#__VIEWSTATE')!.attributes['value'];
          _tokens.viewStateGenerator = document
              .querySelector('#__VIEWSTATEGENERATOR')!
              .attributes['value'];
          _tokens.eventValidation =
              document.querySelector('#__EVENTVALIDATION')!.attributes['value'];
          if (_tokens.viewState != null &&
              _tokens.viewStateGenerator != null &&
              _tokens.eventValidation != null) {
            Map<String, String?> body = {
              '__VIEWSTATE': _tokens.viewState,
              '__VIEWSTATEGENERATOR': _tokens.viewStateGenerator,
              '__EVENTVALIDATION': _tokens.eventValidation,
              "ctl00\$ContentPlaceHolder1\$txtstudent":
                  event.auth!.cred!.username,
              "ctl00\$ContentPlaceHolder1\$btnview": "view"
            };
            GeneralResponse postResponse = await event.session.webClientService
                .postAttendance(event.auth!.cred, event.auth!.token, body);
            if (postResponse.status) {
              // parse attendance

              event.session.setAttendance(postResponse.data.data);
              event.session.setStatus(AttendanceStatus.Loaded);
              yield AttendanceLoaded();
            } else
              throw Exception(postResponse.error);
          } else
            throw Exception(
                "Failed to load attendance! Error at parsing tokens");
        } else {
          yield ShowDialogErrorState(response.error);
          yield AttendanceFailed();
        }
      } on Exception catch (e) {
        event.session.setStatus(AttendanceStatus.Error);

        if (e is DioError) {
          // print("😀 dio error");
          if (e.type == DioErrorType.connectTimeout) {
            yield ShowDialogErrorState(
                "Connection Timeout! Check your internet connectivity and retry again.");
          } else if (e.type == DioErrorType.receiveTimeout) {
            yield ShowDialogErrorState(
                "Connection Timeout! Maybe IPEC Server is down or check your connectivity.");
          } else {
            yield ShowDialogErrorState(
                "Something went wrong! Maybe IPEC Server is down or your internet connectivity is down. Please try again by restarting app");
          }
        } else {
          yield ShowDialogErrorState(e.toString());
        }
        yield AttendanceFailed();
      }
    }
  }
}
