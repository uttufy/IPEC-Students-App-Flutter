import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/widgets/simple_appbar.dart';

class HangoutScreen extends StatefulWidget {
  static const String ROUTE = "/hangout";
  @override
  _HangoutScreenState createState() => _HangoutScreenState();
}

class _HangoutScreenState extends State<HangoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return SafeArea(
      child: Column(
        children: [
          SimpleAppBar(
            onBack: () => Navigator.pop(context),
            title: 'Cafeteria Talks',
          ),
          Onboarding(),
        ],
      ),
    );
  }
}

class Onboarding extends StatelessWidget {
  const Onboarding({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
