import 'package:flutter/material.dart';
import 'package:ipecstudents/data/model/Attendance.dart';
import 'package:ipecstudents/data/repo/auth.dart';
import 'package:ipecstudents/theme/colors.dart';
import 'package:ipecstudents/theme/style.dart';
import 'package:ipecstudents/widgets/general_dialog.dart';
import 'package:ipecstudents/widgets/rounded_button.dart';
import 'package:ipecstudents/widgets/simple_appbar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PredictionResultScreen extends StatefulWidget {
  static const String ROUTE = "/PredictionResultScreen";
  final Attendance attendance;
  final String attend;
  final String total;

  final String result;
  const PredictionResultScreen(
      {Key key, this.attendance, this.result, this.attend, this.total})
      : super(key: key);

  @override
  _PredictionResultScreenState createState() => _PredictionResultScreenState();
}

class _PredictionResultScreenState extends State<PredictionResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, _auth, child) {
        final img = _auth.user.img.toString().split(',')[1];
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                SimpleAppBar(
                  img: img,
                  onPic: () {},
                ),
                kLowPadding,
                Text('Your Result',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.black,
                        )),
                kLowPadding,
                Text(
                  '${widget.result}%',
                  style: Theme.of(context).textTheme.headline3.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                kLowPadding,
                Text(
                    'If you attend ${widget.attend} more lecture\n'
                    'out of ${widget.total} lectures. Your net attendance will be\n',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.black,
                        )),
                kHighPadding,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Lottie.asset('assets/anim/loading.json'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InkWell _button({
    Function onPress,
    Widget child,
  }) {
    return InkWell(
      onTap: onPress,
      borderRadius: BorderRadius.circular(50),
      child: Ink(
        padding: const EdgeInsets.all(10),
        child: child,
      ),
    );
  }
}
