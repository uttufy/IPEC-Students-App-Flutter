import 'dart:ui';

import 'package:ipecstudentsapp/theme/style.dart';
import 'package:ipecstudentsapp/util/SizeConfig.dart';
import 'package:ipecstudentsapp/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/widgets/rounded_button.dart';

class GeneralDialog extends StatefulWidget {
  static Future show(BuildContext context,
      {GlobalKey key,
      String title,
      Widget titleWidget,
      String message,
      Widget child,
      String positiveButtonLabel,
      Function onPositiveTap,
      String negativeButtonLabel,
      Function onNegativeTap,
      bool closeOnAction = true}) async {
    return showDialog(
      context: context,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: GeneralDialog(
          key: key,
          title: title,
          titleWidget: titleWidget,
          message: message,
          child: child,
          positiveButtonLabel: positiveButtonLabel,
          onPositiveTap: onPositiveTap,
          negativeButtonLabel: negativeButtonLabel,
          onNegativeTap: onNegativeTap,
          closeOnAction: closeOnAction,
        ),
      ),
    );
  }

  final String title;
  final Widget titleWidget;
  final String message;
  final Widget child;
  final Function onPositiveTap;
  final String positiveButtonLabel;
  final String negativeButtonLabel;
  final Function onNegativeTap;
  final bool closeOnAction;

  GeneralDialog(
      {GlobalKey key,
      this.title,
      this.titleWidget,
      this.message,
      this.child,
      this.positiveButtonLabel,
      this.onPositiveTap,
      this.negativeButtonLabel,
      this.onNegativeTap,
      this.closeOnAction})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GeneralDialogState(
        title: this.title,
        titleWidget: this.titleWidget,
        message: this.message,
        child: this.child,
        positiveButtonLabel: this.positiveButtonLabel,
        onPositiveTap: this.onPositiveTap,
        negativeButtonLabel: this.negativeButtonLabel,
        onNegativeTap: this.onNegativeTap,
        closeOnAction: this.closeOnAction);
  }
}

class _GeneralDialogState extends State {
  final String title;
  final Widget titleWidget;
  final String message;
  final Widget child;
  final Function onPositiveTap;
  final String positiveButtonLabel;
  final String negativeButtonLabel;
  final Function onNegativeTap;
  final bool closeOnAction;

  ThemeData _themeData;

  _GeneralDialogState(
      {this.title,
      this.titleWidget,
      this.message,
      this.child,
      this.positiveButtonLabel,
      this.onPositiveTap,
      this.negativeButtonLabel,
      this.onNegativeTap,
      this.closeOnAction})
      : assert(title != null || titleWidget != null);

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.3),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: CloseButton(
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: _themeData.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(30)),
                        child: Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              titleWidget ??
                                  Text(
                                    title.toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                              kMedPadding,
                              child ??
                                  Text(
                                    message,
                                    textAlign: TextAlign.center,
                                  ),
                              kHighPadding,
                              Container(
                                width: double.maxFinite,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    negativeButtonLabel != null
                                        ? Expanded(
                                            child: Center(
                                              child: RaisedButton(
                                                color: Colors.white,
                                                child:
                                                    Text(negativeButtonLabel),
                                                onPressed: () {
                                                  if (onPositiveTap != null) {
                                                    onNegativeTap();
                                                  } else {
                                                    Navigator.pop(context);
                                                  }
                                                },
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    Expanded(
                                      child: RoundedButton(
                                        press: () {
                                          if (onPositiveTap != null) {
                                            if (closeOnAction)
                                              Navigator.pop(context);
                                            onPositiveTap();
                                          } else {
                                            Navigator.pop(context);
                                          }
                                        },
                                        text: positiveButtonLabel ?? 'OK',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
