import 'package:flutter/material.dart';
import 'package:ipecstudents/theme/colors.dart';
import 'package:ipecstudents/widgets/background.dart';
import 'package:lottie/lottie.dart';
import 'package:mantras/mantras.dart';

class LoadingScreen extends StatelessWidget {
  static const String ROUTE = "/Loading";
  // Retrieve single mantra
  String mantra = Mantras().getMantra();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            Positioned(
              bottom: 0,
              child: Container(
                width: size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Flexible(
                  child: Text(
                    "Mantra : " + mantra,
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    style:
                        Theme.of(context).primaryTextTheme.bodyText1.copyWith(
                              color: kGrey,
                            ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
