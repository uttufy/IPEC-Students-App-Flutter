import '../../../data/base_bloc/base_bloc.dart';
import '../../../data/base_bloc/base_event.dart';
import '../../../data/base_bloc/base_state.dart';
import '../../../data/local/shared_pref.dart';
import '../../../data/model/Cred.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashScreenBloc extends BaseBloc {
  @override
  BaseState get initialState => SplashInitState();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    LocalData _localData = LocalData();
    if (event is CheckUserAuth) {
      await Future.delayed(Duration(seconds: 1));
      bool isLogin = await _localData.getLoginStatus();

      if (isLogin != null && isLogin) {
        String username = await _localData.getUsername();
        String password = await _localData.getPassword();
        bool loginStatus = await _localData.getLoginStatus();

        if (username != null && password != null && loginStatus) {
          //  Username and Password Exist
          event.auth.cred = Cred(username: username, password: password);
          yield OpenDashboardScreen();
        } else
          yield OpenAuthenticationScreen();
      } else
        yield OpenAuthenticationScreen();
    }
  }
}
