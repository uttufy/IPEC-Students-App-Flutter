import 'package:flutter/material.dart';
import 'package:ipecstudents/screens/login/login_screen.dart';
import 'package:ipecstudents/screens/splash/splash_screen.dart';
import 'package:ipecstudents/theme/style.dart';
import 'package:ipecstudents/util/SizeConfig.dart';
import 'package:provider/provider.dart';

class Routes {
  Routes() {
    runApp(LayoutBuilder(builder: (context, constraints) {
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
    }));
  }

  Route onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.ROUTE:
        return _getMaterialRoute(SplashScreen(), settings);
      case LoginScreen.ROUTE:
        return _getMaterialRoute(LoginScreen(), settings);
      // case MainWebView.ROUTE:
      //   Map arg = settings.arguments;
      //   return _getMaterialRoute(
      //       MainWebView(
      //         title: arg['title'],
      //         url: arg['url'],
      //       ),
      //       settings);
      // case LiveMatchScoreScreen.ROUTE:
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
