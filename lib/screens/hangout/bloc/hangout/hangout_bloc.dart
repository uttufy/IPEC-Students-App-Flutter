import 'package:ipecstudentsapp/data/model/hangout/hangUser.dart';

import '../../../../../data/base_bloc/base_bloc.dart';
import '../../../../../data/base_bloc/base_event.dart';
import '../../../../../data/base_bloc/base_state.dart';
import '../../../../util/helper.dart';
import 'hangout_event.dart';
import 'hangout_state.dart';

class HangoutBloc extends BaseBloc {
  @override
  BaseState get initialState => HangoutInitState();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is CheckUserEvent) {
      yield HangoutLoading();

      final res = await checkUserExist(event.user.id);

      if (res['exists']) {
        final huser = Huser.fromMap(res['data']);

        yield UserExistState(huser);
      } else {
        yield UserNotExistState();
      }
    }
    if (event is OnboardFinishEvent) {
      yield UserExistState(event.huser);
    }
  }
}
