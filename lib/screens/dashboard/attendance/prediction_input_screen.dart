import 'package:flutter/material.dart';
import '../../../data/model/Attendance.dart';
import '../../../data/repo/auth.dart';
import 'prediction_result_screen.dart';

import '../../../theme/style.dart';
import '../../../widgets/general_dialog.dart';
import '../../../widgets/rounded_button.dart';
import '../../../widgets/simple_appbar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PredictionInputScreen extends StatefulWidget {
  static const String ROUTE = "/PredictionInputScreen";
  final Attendance attendance;

  const PredictionInputScreen({Key key, this.attendance}) : super(key: key);

  @override
  _PredictionInputScreenState createState() => _PredictionInputScreenState();
}

class _PredictionInputScreenState extends State<PredictionInputScreen> {
  int total = 8;
  int attend = 0;

  String calculatePercent() {
    print(widget.attendance.getPresentLectures());
    int a = int.parse(widget.attendance.getPresentLectures());
    int b = int.parse(widget.attendance.getTotalLectures());
    double percent = ((a + attend) / (b + total)) * 100;
    return percent.toStringAsFixed(2);
  }

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
                  onBack: () {
                    Navigator.pop(context);
                  },
                ),
                kLowPadding,
                Text('Total Lectures Tommorow ?',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.black,
                        )),
                kLowPadding,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _button(
                        onPress: () {
                          setState(() {
                            total++;
                          });
                        },
                        child: Icon(
                          Icons.add,
                          size: 20,
                        )),
                    kMedWidthPadding,
                    Text(
                      total.toString(),
                      style: Theme.of(context).textTheme.headline3.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                    kMedWidthPadding,
                    _button(
                        onPress: () {
                          if (total > 0)
                            setState(() {
                              total--;
                            });
                        },
                        child: Icon(
                          Icons.remove,
                          size: 20,
                        )),
                  ],
                ),
                kHighPadding,
                Text('How many are you going to attend ?',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.black,
                        )),
                kLowPadding,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _button(
                      onPress: () {
                        if (attend < total)
                          setState(() {
                            attend++;
                          });
                      },
                      child: Icon(
                        Icons.add,
                        size: 20,
                      ),
                    ),
                    kMedWidthPadding,
                    Text(
                      attend.toString(),
                      style: Theme.of(context).textTheme.headline3.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                    kMedWidthPadding,
                    _button(
                        onPress: () {
                          if (attend > 0)
                            setState(() {
                              attend--;
                            });
                        },
                        child: Icon(
                          Icons.remove,
                          size: 20,
                        )),
                  ],
                ),
                Expanded(
                  child: Lottie.asset('assets/anim/data.json'),
                ),
                RoundedButton(
                  text: 'Calulate',
                  press: () {
                    try {
                      String res = calculatePercent();
                      Navigator.pushNamed(context, PredictionResultScreen.ROUTE,
                          arguments: {
                            'attendance': widget.attendance,
                            'result': res,
                            'attend': attend.toString(),
                            'total': total.toString()
                          });
                    } on Exception catch (e) {
                      GeneralDialog.show(context,
                          title: "Error",
                          message: e.toString() ?? "Something went wrong");
                    }
                  },
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
