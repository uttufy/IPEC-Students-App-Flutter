import 'package:flutter/material.dart';
import 'package:ipecstudents/widgets/background.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  static const String ROUTE = "/Loading";
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Background(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              'Loading',
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline5
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w700),
            ),
            Lottie.asset('assets/anim/loading2.json'),
          ],
        ),
      ),
    );
  }
}
