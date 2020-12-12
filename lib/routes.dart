import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/screens/dashboard/attendance/attendance_page.dart';
import 'package:ipecstudentsapp/screens/dashboard/attendance/attendance_screen.dart';
import 'package:ipecstudentsapp/screens/dashboard/attendance/prediction_input_screen.dart';
import 'package:ipecstudentsapp/screens/dashboard/attendance/prediction_result_screen.dart';
import 'package:ipecstudentsapp/screens/dashboard/dashboard_page.dart';
import 'package:ipecstudentsapp/screens/loading/loading_screen.dart';
import 'package:ipecstudentsapp/screens/login/login_screen.dart';
import 'package:ipecstudentsapp/screens/splash/splash_screen.dart';
import 'package:ipecstudentsapp/theme/style.dart';
import 'package:ipecstudentsapp/util/SizeConfig.dart';
import 'package:provider/provider.dart';

import 'data/repo/auth.dart';
import 'data/repo/session.dart';

class Routes {
  Routes() {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider<Session>(
          create: (context) => Session(),
        ),
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);

          return MaterialApp(
            title: "IPEC Students App",
            home: SplashScreen(),
            theme: appTheme,
            onGenerateRoute: onGenerate,
            debugShowCheckedModeBanner: false,
          );
        });
      }),
    ));
  }

  Route onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.ROUTE:
        return _getMaterialRoute(SplashScreen(), settings);
      case LoginScreen.ROUTE:
        return _getMaterialRoute(LoginScreen(), settings);
      case LoadingScreen.ROUTE:
        Map arg = settings.arguments;
        return _getMaterialRoute(
            LoadingScreen(
              isFirstLogin: arg['isFirstLogin'],
            ),
            settings);
      case DashboardScreen.ROUTE:
        return _getMaterialRoute(DashboardScreen(), settings);
      case AttendanceScreen.ROUTE:
        return _getMaterialRoute(AttendanceScreen(), settings);
      case AttendancePage.ROUTE:
        return _getMaterialRoute(AttendancePage(), settings);
      case PredictionInputScreen.ROUTE:
        Map arg = settings.arguments;
        return _getMaterialRoute(
            PredictionInputScreen(
              attendance: arg['attendance'],
            ),
            settings);
      case PredictionResultScreen.ROUTE:
        Map arg = settings.arguments;
        return _getMaterialRoute(
            PredictionResultScreen(
                attendance: arg['attendance'],
                result: arg['result'],
                attend: arg['attend'],
                total: arg['total']),
            settings);

      default:
        return _getMaterialRoute(SplashScreen(), settings);
    }
  }

  static Route _getMaterialRoute(Widget widge, RouteSettings settings) {
    return MaterialPageRoute(
        builder: (BuildContext context) {
          return widge;
        },
        settings: settings);
  }
}
