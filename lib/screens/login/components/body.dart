import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipecstudents/screens/loading/loading_screen.dart';
import 'package:ipecstudents/widgets/background.dart';
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
    Size size = MediaQuery.of(context).size;
    return Background(
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
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                Navigator.pushNamed(context, LoadingScreen.ROUTE);
              },
            ),
            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }
}
