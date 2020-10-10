import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData appTheme = new ThemeData(
  hintColor: Colors.white,
  fontFamily: 'Averta',
  primaryColor: kOrange,
  accentColor: kOrange,
  scaffoldBackgroundColor: kLightBg,
  inputDecorationTheme: InputDecorationTheme(
    fillColor: kLighterGrey,
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(kLowCircleRadius),
    ),
  ),
);

const kLowCircleRadius = 20.0;
const kMedCircleRadius = 30.0;

// Text
const kHeadingSize = 4.0;
const kBodySize = 3.0;
const kParagraphSize = 2.0;

//Padding
const kLowPadding = SizedBox(
  height: 10,
);
const kMedPadding = SizedBox(
  height: 20,
);
const kHighPadding = SizedBox(
  height: 30,
);

const kLowWidthPadding = SizedBox(
  width: 10,
);
const kMedWidthPadding = SizedBox(
  width: 20,
);
const kHighWidthPadding = SizedBox(
  width: 30,
);

const kBoldH3 = TextStyle(fontWeight: FontWeight.bold);
