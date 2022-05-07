import '../../../data/model/GeneralResponse.dart';
import '../../../theme/colors.dart';

import '../../../data/base_bloc/base_bloc.dart';
import '../../../data/base_bloc/base_event.dart';
import '../../../data/base_bloc/base_state.dart';
import 'sessional_event.dart';
import 'sessional_state.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class SessionalBloc extends BaseBloc {
  SessionalBloc(BaseState initialState) : super(initialState);

  @override
  BaseState get initialState => SessionalInitial();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is SessionalLoadEvent) {
      yield SessionalLoadingState();
      GeneralResponse response = await event.session.webClientService
          .getSessional(event.auth!.token.cookies);
      if (response.status) {
        try {
          var document = parse(response.data);
          String? changedHtml =
              document.querySelector("#right > table")!.outerHtml;

          changedHtml = changedHtml.replaceAll('Black', '#f44336');
          // changedHtml = changedHtml.replaceAll('White', '#1D2C4B');
          // changedHtml = changedHtml.replaceAll('#333333', 'White');
          // changedHtml = changedHtml.replaceAll('White', 'Black');
          // changedHtml = changedHtml.replaceAll('#333333', 'White');

          changedHtml = changedHtml.replaceAll('#006699', '#6F35A5');
          changedHtml = changedHtml.replaceAll(
              '<input type="submit" name="ctl00\$ContentPlaceHolder1\$btnClose" value="Close" id="ContentPlaceHolder1_btnClose" class="button">',
              '');
          yield AllSessionalLoadedState(changedHtml);
        } on Exception catch (e) {
          yield SessionalErrorState(
              "Failed to load sessional marks!\nError : ${e.toString()}");
        }
      } else
        yield SessionalErrorState("Failed to load sessional marks!");
    }
  }
}
