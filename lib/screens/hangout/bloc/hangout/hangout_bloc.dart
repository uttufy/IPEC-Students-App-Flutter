import 'package:firebase_database/firebase_database.dart';
import 'package:ipecstudentsapp/data/model/GeneralResponse.dart';
import 'package:html/parser.dart';
import '../../../../../data/base_bloc/base_bloc.dart';
import '../../../../../data/base_bloc/base_event.dart';
import '../../../../../data/base_bloc/base_state.dart';
import '../../../../data/model/hangout/hangUser.dart';
import '../../../../util/helper.dart';
import 'hangout_event.dart';
import 'hangout_state.dart';

class HangoutBloc extends BaseBloc {
  HangoutBloc(BaseState initialState) : super(initialState);

  @override
  BaseState get initialState => HangoutInitState();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is CheckUserEvent) {
      yield HangoutLoading();

      final res = await checkUserExist(event.auth.user!.id);

      if (res['exists']) {
        final huser = Huser.fromMap(res['data']);
        print(huser.isBanned);
        if (huser.isBanned!)
          yield UserBannedState();
        else
          yield UserExistState(huser);

        // update user profile

        GeneralResponse response = await event.session.webClientService
            .getMyProfile(event.auth.token.cookies);
        if (response.status) {
          var document = parse(response.data);
          String? depart = document
              .querySelector("#ContentPlaceHolder1_lblDepartment")!
              .attributes["value"];

          String? yr = document
              .querySelector("#ContentPlaceHolder1_lblYear")!
              .attributes["value"];

          String? section = document
              .querySelector("#ContentPlaceHolder1_lblBranch")!
              .attributes["value"];

          FirebaseDatabase.instance
              .reference()
              .child('hangout')
              .child('user')
              .child(event.auth.user!.id)
              .update({"depart": depart, "yr": yr, "section": section});
        }
      } else {
        yield UserNotExistState();
      }
    }
    if (event is OnboardFinishEvent) {
      yield UserExistState(event.huser);
    }
  }
}
