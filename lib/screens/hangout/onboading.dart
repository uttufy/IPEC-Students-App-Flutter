import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_bloc_builder.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_bloc_listener.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_state.dart';
import 'package:ipecstudentsapp/data/model/hangUser.dart';
import 'package:ipecstudentsapp/data/repo/auth.dart';
import 'package:ipecstudentsapp/data/repo/session.dart';
import 'package:ipecstudentsapp/screens/hangout/bloc/onboarding_event.dart';
import 'package:ipecstudentsapp/screens/hangout/bloc/onboarding_state.dart';
import 'package:ipecstudentsapp/theme/style.dart';
import 'package:provider/provider.dart';

import 'bloc/onboarding_bloc.dart';

class Onboarding extends StatefulWidget {
  final Auth auth;
  const Onboarding({
    Key key,
    this.auth,
  }) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final _bloc = OnboardingBloc();

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;

    return Consumer<Session>(builder: (context, session, child) {
      return BaseBlocListener(
          bloc: _bloc,
          listener: (BuildContext context, BaseState state) {
            print("$runtimeType BlocListener - ${state.toString()}");
          },
          child: BaseBlocBuilder(
              bloc: _bloc,
              condition: (BaseState previous, BaseState current) {
                return !(BaseBlocBuilder.isBaseState(current));
              },
              builder: (BuildContext context, BaseState state) {
                print("$runtimeType BlocBuilder - ${state.toString()}");

                if (state is OnboardingInitState) {
                  _bloc.add(LoadStudentData(widget.auth, session));
                }
                if (state is OnboardingLoading)
                  return Center(child: CircularProgressIndicator());
                if (state is OnboardingLoaded)
                  return _getbody(context, isDark, state.user);
                return Center(
                  child: Text("Something went wrong try again!"),
                );
              }));
    });
  }

  Widget _getbody(BuildContext context, bool isDark, Huser user) {
    final gender = user.gender.contains(":")
        ? user.gender.split(":")[1].trim()
        : user.gender;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Next'),
        icon: Icon(Icons.arrow_forward_ios),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Let\'s get you setup,',
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: isDark ? Colors.white : Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.auth.user.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            kLowPadding,
            _getTexts('Email', user.email, isDark),
            _getTexts('Phone Number', user.phone, isDark),
            _getTexts('Class', user.section, isDark),
            _getTexts('Year', user.yr, isDark),
            _getTexts('Department', user.depart, isDark),
            _getTexts('Gender', gender, isDark),
          ],
        ),
      ),
    );
  }

  _getTexts(String s, String t, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: isDark ? Colors.white : Colors.black,
                ),
          ),
          // kMedPadding,
          Text(
            t,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
