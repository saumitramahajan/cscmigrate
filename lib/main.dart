import 'package:flutter/material.dart';
import 'package:mahindraCSC/roles/admin/changePassword/changePassword.dart';
import 'package:mahindraCSC/roles/admin/dashboard/routeBase.dart';
import 'package:mahindraCSC/roles/admin/dashboard/routeSiteBase.dart';
import 'package:mahindraCSC/utilities.dart';
import 'package:mahindraCSC/y_check/checkBase.dart';

Future<void> main() async {
  runApp(MyApp());
}

Map<int, Color> colorc = {
  50: Color.fromRGBO(227, 24, 54, .1),
  100: Color.fromRGBO(227, 24, 54, .2),
  200: Color.fromRGBO(227, 24, 54, .3),
  300: Color.fromRGBO(227, 24, 54, .4),
  400: Color.fromRGBO(227, 24, 54, .5),
  500: Color.fromRGBO(227, 24, 54, .6),
  600: Color.fromRGBO(227, 24, 54, .7),
  700: Color.fromRGBO(227, 24, 54, .8),
  800: Color.fromRGBO(227, 24, 54, .9),
  900: Color.fromRGBO(227, 24, 54, 1),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Utilities utilities = Utilities();
  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xffE31836, colorc);
    // SystemChrome.setPreferredOrientations([
    //   /*DeviceOrientation.landscapeLeft, */ DeviceOrientation.landscapeRight
    // ]);
    return MaterialApp(
        title: 'TMSW',
        initialRoute: '/',
        routes: {
          '/': (context) => CheckBase(),
          '/selfAssessmentReview': (context) => RouteBase(),
          '/siteAssessmentReview': (context) => RouteSiteBase(),
          '/changePassword': (context) => ChangePassword()
        },
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: colorCustom,
          cursorColor: colorCustom,

          fontFamily: 'Lato',
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: CheckBase());
  }
}
