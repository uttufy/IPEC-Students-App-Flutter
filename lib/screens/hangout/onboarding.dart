import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

import '../../data/base_bloc/base_bloc_builder.dart';
import '../../data/base_bloc/base_bloc_listener.dart';
import '../../data/base_bloc/base_state.dart';
import '../../data/model/hangout/hangUser.dart';
import '../../data/repo/auth.dart';
import '../../data/repo/session.dart';
import '../../theme/style.dart';
import '../../widgets/loading_widget.dart';
import 'bloc/onboarding/onboarding_bloc.dart';
import 'bloc/onboarding/onboarding_event.dart';
import 'bloc/onboarding/onboarding_state.dart';

class Onboarding extends StatefulWidget {
  final Auth auth;
  final VoidCallback onDone;
  const Onboarding({
    Key key,
    this.auth,
    this.onDone,
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
    final bool isDark =
        AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;

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
                  return Center(child: LoadingWidget());
                if (state is OnboardingLoaded) {
                  Provider.of<Auth>(context, listen: false).hUser = state.user;
                  return _getbody(context, isDark, state.user);
                }
                if (state is SavedUserState) {
                  return _getIntro();
                }
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
        onPressed: () {
          _bloc.add(SaveStudentDataEvent(user));
        },
        label: Text(
          'NEXT',
        ),
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
                  .bodyText1
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

  Widget _getIntro() {
    return IntroductionScreen(
        pages: [
          PageViewModel(
            title: "College Exclusive\nCommunity",
            body: "Help us grow! Invite your classmates",
            image: Center(
              child: Image.network(
                  "https://i.postimg.cc/RCk7DQ0c/pngaaa-com-2557797.png",
                  height: 175.0),
            ),
          ),
          PageViewModel(
            title: "Connect, Share & Enjoy",
            body: "The best way to connect with your college peers",
            image: Center(
              child: Image.network(
                  "https://i.postimg.cc/Qtp8x3pN/Pin-Clipart-com-mafia-clip-art-5375273.png",
                  height: 175.0),
            ),
          ),
          PageViewModel(
            title: "Keep It Clean",
            body:
                "Any bad activity or use of bad language will lead to straight up ban",
            image: Center(
              child: Image.network(
                  "https://i.postimg.cc/8zhtHXBJ/Pin-Clipart-com-bboy-clipart-3526409.png",
                  height: 175.0),
            ),
          ),
        ],
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
        onDone: () {
          // When done button is press

          widget.onDone();
        },
        next: Text(
          'Next',
          style: TextStyle(fontWeight: FontWeight.bold),
        )); //Material App
  }
}
