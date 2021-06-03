import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_bloc_builder.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_bloc_listener.dart';
import 'package:ipecstudentsapp/data/base_bloc/base_state.dart';
import 'package:ipecstudentsapp/data/repo/auth.dart';
import 'package:ipecstudentsapp/widgets/simple_appbar.dart';
import 'package:provider/provider.dart';

import 'onboading.dart';

class HangoutScreen extends StatefulWidget {
  static const String ROUTE = "/hangout";
  @override
  _HangoutScreenState createState() => _HangoutScreenState();
}

class _HangoutScreenState extends State<HangoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _getBody());
  }

  Widget _getBody() {
    return SafeArea(
      child: Column(
        children: [
          SimpleAppBar(
            onBack: () => Navigator.pop(context),
            title: 'Cafeteria Talks',
          ),
          Consumer<Auth>(builder: (context, auth, child) {
            return Expanded(child: Onboarding(auth: auth));
          }),
        ],
      ),
    );
  }
}
