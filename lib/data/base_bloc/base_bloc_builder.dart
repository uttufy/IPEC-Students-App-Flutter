import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_bloc.dart';
import 'base_state.dart';

class BaseBlocBuilder extends BlocBuilderBase<BaseBloc, BaseState> {
  /// The [Bloc] that the [BlocBuilder] will interact with.
  final BaseBloc bloc;

  /// The `builder` function which will be invoked on each widget build.
  /// The `builder` takes the [BuildContext] and current bloc state and
  /// must return a [Widget].
  /// This is analogous to the `builder` function in [StreamBuilder].
  final BlocWidgetBuilder<BaseState> builder;

  /// The `condition` function will be invoked on each bloc state change.
  /// The `condition` takes the previous state and current state and must return a `bool`
  /// which determines whether or not the `builder` function will be invoked.
  /// The previous state will be initialized to `currentState` when the `BlocBuilder` is initialized.
  /// `condition` is optional and if it isn't implemented, it will default to return `true`.
  final BlocBuilderCondition<BaseState> condition;

  const BaseBlocBuilder({
    Key? key,
    required this.bloc,
    required this.builder,
    required this.condition,
  }) : super(key: key, bloc: bloc);

  @override
  Widget build(BuildContext context, BaseState state) {
    // print("${runtimeType} - ${state.toString()}");
    return builder(context, state);
  }

  static bool isBaseState(BaseState state) {
    return (state is ShowDialogErrorState ||
        state is ShowProgressLoader ||
        state is PlaceHolderState ||
        state is ShowSnackBarErrorState);
  }

//  @override
//  Widget build(BuildContext context, S state) => builder(context, state);
}
