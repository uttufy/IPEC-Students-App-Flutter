import 'package:flutter/material.dart';
import 'package:ipecstudents/screens/splash/splash_screen.dart';
import 'package:ipecstudents/util/SizeConfig.dart';
import 'package:provider/provider.dart';

class Routes {
  Routes() {
    runApp(MultiProvider(
      providers: [
        // ChangeNotifierProvider<ScoreRepo>(
        //   create: (context) => ScoreRepo(),
        // ),
        // ChangeNotifierProvider<UserRepo>(
        //   create: (context) => UserRepo(),
        // )
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);

          return MaterialApp(
            title: "IPEC Students",
            home: SplashScreen(),
            // theme: appTheme,
            onGenerateRoute: onGenerate,
            debugShowCheckedModeBanner: false,
          );
        });
      }),
    ));
  }

  Route onGenerate(RouteSettings settings) {
    switch (settings.name) {
      // case HomePage.ROUTE:
      //   return _getMaterialRoute(HomePage(), settings);
      // case MainWebView.ROUTE:
      //   Map arg = settings.arguments;
      //   return _getMaterialRoute(
      //       MainWebView(
      //         title: arg['title'],
      //         url: arg['url'],
      //       ),
      //       settings);
      // case LiveMatchScoreScreen.ROUTE:
      // default:
      // return _getMaterialRoute(SplashScreen(), settings);
    }
  }

  static Route _getMaterialRoute(Widget widget, RouteSettings settings) {
    return MaterialPageRoute(
        builder: (BuildContext context) {
          return widget;
        },
        settings: settings);
  }
}
