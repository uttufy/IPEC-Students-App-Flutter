import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../data/model/Cred.dart';
import '../../../data/repo/auth.dart';
import '../../../theme/colors.dart';
import '../../../widgets/background.dart';
import '../../../widgets/rounded_button.dart';
import '../../../widgets/rounded_input_field.dart';
import '../../../widgets/rounded_password_field.dart';
import '../../loading/loading_screen.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _username = "";
  String _password = "";
  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        // ignore: deprecated_member_use
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
    return Scaffold(
      key: _scaffoldKey,
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  // SizedBox(),
                  // Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      "LOGIN",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      print("Mode change");
                      setState(() {
                        if (isDark) {
                          AdaptiveTheme.of(context).setLight();
                        } else {
                          AdaptiveTheme.of(context).setDark();
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: isDark
                                  ? kPrimaryColor.withOpacity(0.3)
                                  : kBlue.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(50)),
                          child: Icon(Icons.wb_sunny)),
                    ),
                  )
                ],
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
                    Provider.of<Auth>(context, listen: false).cred =
                        Cred(username: _username, password: _password);

                    Navigator.pushNamed(context, LoadingScreen.ROUTE,
                        arguments: {'isFirstLogin': true});
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
