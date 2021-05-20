import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repo/auth.dart';
import 'data/repo/session.dart';
import 'screens/about/about.dart';
import 'screens/dashboard/attendance/attendance_page.dart';
import 'screens/dashboard/attendance/attendance_screen.dart';
import 'screens/dashboard/attendance/prediction_input_screen.dart';
import 'screens/dashboard/attendance/prediction_result_screen.dart';
import 'screens/dashboard/dashboard_page.dart';
import 'screens/loading/loading_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/notices/notices_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'theme/style.dart';
import 'util/SizeConfig.dart';

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
          Firebase.initializeApp();

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
      case NoticesScreen.ROUTE:
        return _getMaterialRoute(NoticesScreen(), settings);
      case AboutScreen.ROUTE:
        return _getMaterialRoute(AboutScreen(), settings);
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
