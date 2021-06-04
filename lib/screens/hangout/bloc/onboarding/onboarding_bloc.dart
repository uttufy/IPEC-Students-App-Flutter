import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:html/parser.dart';
import '../../../../data/model/GeneralResponse.dart';
import '../../../../data/model/hangUser.dart';
import 'onboarding_event.dart';

import '../../../../../data/base_bloc/base_bloc.dart';
import '../../../../../data/base_bloc/base_event.dart';
import '../../../../../data/base_bloc/base_state.dart';
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
    if (event is SaveStudentDataEvent) {
      try {
        FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: event.user.email, password: event.user.id);

        FirebaseDatabase.instance
            .reference()
            .child('hangout')
            .child('user')
            .child(event.user.id)
            .set(event.user.toMap());

        yield SavedUserState(event.user);
      } catch (e) {
        yield ShowDialogErrorState(e.toString());
      }
    }
  }
}
