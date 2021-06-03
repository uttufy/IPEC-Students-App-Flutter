import 'package:html/parser.dart';
import 'package:ipecstudentsapp/data/model/GeneralResponse.dart';
import 'package:ipecstudentsapp/data/model/hangUser.dart';
import 'package:ipecstudentsapp/screens/hangout/bloc/onboarding_event.dart';

import '../../../../data/base_bloc/base_bloc.dart';
import '../../../../data/base_bloc/base_event.dart';
import '../../../../data/base_bloc/base_state.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends BaseBloc {
  @override
  BaseState get initialState => OnboardingInitState();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadStudentData) {
      yield OnboardingLoading();
      GeneralResponse response = await event.session.webClientService
          .getMyProfile(event.auth.token.cookies);
      if (response.status) {
        var document = parse(response.data);

        String email = document
            .querySelector("#ContentPlaceHolder1_lblStudentEMail")
            .attributes["value"];

        String gender = document
            .querySelector("#ContentPlaceHolder1_lblGender")
            .attributes["value"];

        String phone = document
            .querySelector("#ContentPlaceHolder1_lblStudentMoileNo")
            .attributes["value"];

        String depart = document
            .querySelector("#ContentPlaceHolder1_lblDepartment")
            .attributes["value"];

        String yr = document
            .querySelector("#ContentPlaceHolder1_lblYear")
            .attributes["value"];

        String section = document
            .querySelector("#ContentPlaceHolder1_lblBranch")
            .attributes["value"];

        Huser user = Huser(
            depart: depart,
            email: email,
            gender: gender,
            id: event.auth.user.id,
            name: event.auth.user.name,
            phone: phone,
            section: section,
            yr: yr);

        yield OnboardingLoaded(user);
      } else {
        yield ShowDialogErrorState(response.error.toString());
      }
    }
  }
}
