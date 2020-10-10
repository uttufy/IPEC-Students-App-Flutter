import 'package:ipecstudents/widgets/general_dialog.dart';
import 'package:ipecstudents/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import 'base_bloc.dart';
import 'base_event.dart';
import 'base_state.dart';

class BaseBlocListener<B extends BaseBloc, S extends BaseState>
    extends BlocListenerBase {
  /// The [Bloc] whose state will be listened to.
  /// Whenever the bloc's state changes, `listener` will be invoked.
  final B bloc;

  /// The [BlocWidgetListener] which will be called on every state change (including the `initialState`).
  /// This listener should be used for any code which needs to execute
  /// in response to a state change (`Transition`).
  /// The state will be the `nextState` for the most recent `Transition`.
//  final BlocWidgetListener<S> listener;

  /// The [Widget] which will be rendered as a descendant of the [BlocListener].
  final Widget child;

  final ProgressDialog pd = null;

  BaseBlocListener({
    Key key,
    @required this.bloc,
    @required BlocWidgetListener<S> listener,
    this.child,
  })  : assert((bloc is BaseBloc), "Bloc should be instance of BaseBlock !!"),
        super(
          key: key,
          bloc: bloc,
          child: child,
          listener: (context, state) {
            ProgressDialog.getInstance().hide(context: context);

            if (state is ShowDialogInfoState) {
              GeneralDialog.show(context,
                  title: state.title, message: state.message);
              bloc.add(PlaceHolderEvent());
            }

            if (state is ShowDialogErrorState) {
              GeneralDialog.show(context, title: 'Error', message: state.error);
              bloc.add(PlaceHolderEvent());
            }

            if (state is ShowSnackBarErrorState) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  duration: Duration(seconds: 3),
                ),
              );
              bloc.add(PlaceHolderEvent());
            }
            if (state is ShowProgressLoader) {
              ProgressDialog.getInstance().show(context, state.message);
            }

            if (state is LogoutState) {
              GeneralDialog.show(context,
                  title: 'Logout',
                  message: 'Do you really want to logout?',
                  positiveButtonLabel: 'LOGOUT', onPositiveTap: () async {
                // await FirebaseAuth.instance.signOut();
                // await GoogleSignIn().signOut();
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     SplashScreen.ROUTE_NAME, (route) => false);
              });
            }

            listener(context, state);
          },
        );
}
