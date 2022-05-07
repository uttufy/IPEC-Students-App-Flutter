import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../data/repo/auth.dart';
import '../../../theme/style.dart';
import '../../../widgets/simple_appbar.dart';

class PredictionResultScreen extends StatefulWidget {
  static const String ROUTE = "/PredictionResultScreen";
  final double attendance;
  final String? attend;
  final String? total;

  final double result;
  const PredictionResultScreen(
      {Key? key,
      required this.attendance,
      required this.result,
      this.attend,
      this.total})
      : super(key: key);

  @override
  _PredictionResultScreenState createState() => _PredictionResultScreenState();
}

class _PredictionResultScreenState extends State<PredictionResultScreen> {
  int state = 0;

  @override
  void initState() {
    super.initState();
    if (widget.attendance < widget.result)
      state = 1;
    else if (widget.attendance > widget.result) state = -1;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
    return Consumer<Auth>(
      builder: (context, _auth, child) {
        final img = _auth.user!.img.toString().split(',')[1];
        final textColor = state == 1
            ? kGreen
            : state == -1
                ? kOrange
                : isDark
                    ? Colors.white
                    : Colors.black;
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SimpleAppBar(
                  img: img,
                  onPic: () {},
                  onBack: () {
                    Navigator.pop(context);
                  },
                ),
                kLowPadding,
                Text('Your Result',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: isDark ? Colors.white : Colors.black,
                        )),
                kLowPadding,
                Text(
                  '${widget.result.toStringAsFixed(2)}%',
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: textColor, fontWeight: FontWeight.w700),
                ),
                kLowPadding,
                Text(
                    'If you attend ${widget.attend} more lecture\n'
                    'out of ${widget.total} lectures.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: isDark ? Colors.white : Colors.black,
                        )),
                kMedPadding,
                Visibility(
                  visible: state != 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        state == 1
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: textColor,
                        size: 30,
                      ),
                      Text(
                        ((state > 0 ? "+" : "-") +
                            (widget.attendance - widget.result)
                                .abs()
                                .toStringAsFixed(2)),
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                ),
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
}
