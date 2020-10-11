import 'package:flutter/material.dart';
import 'package:ipecstudents/data/base_bloc/base_event.dart';
import 'package:ipecstudents/data/base_bloc/base_state.dart';
import 'package:ipecstudents/data/model/Cred.dart';
import 'package:ipecstudents/screens/loading/loading_screen.dart';
import 'package:ipecstudents/widgets/background.dart';
import 'package:ipecstudents/widgets/general_dialog.dart';
import 'package:ipecstudents/widgets/rounded_button.dart';
import 'package:ipecstudents/widgets/rounded_input_field.dart';
import 'package:ipecstudents/widgets/rounded_password_field.dart';
import 'package:lottie/lottie.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    String _username;
    String _password;
    Size size = MediaQuery.of(context).size;

    void showInSnackBar(String value) {
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text(value)));
    }

    return Scaffold(
      key: _scaffoldKey,
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
              SizedBox(height: size.height * 0.03),
              Lottie.asset(
                "assets/anim/login.json",
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Your College ID",
                onChanged: (value) => _username = value,
              ),
              RoundedPasswordField(
                onChanged: (value) => _password = value,
              ),
              RoundedButton(
                text: "LOGIN",
                press: () {
                  if (validateInput(_username, _password)) {
                    Navigator.pushNamed(context, LoadingScreen.ROUTE,
                        arguments: {
                          'cred': Cred(username: _username, password: _password)
                        });
                  } else
                    showInSnackBar('Please check your entries!');
                },
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  bool validateInput(String username, String password) {
    if (username != null &&
        password != null &&
        username.length != 0 &&
        password.length != 0) return true;
    return false;
  }
}
