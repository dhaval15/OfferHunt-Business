import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offerhuntbusiness/colors.dart';

import 'api/api.dart';
import 'screens/screens.dart';
import 'package:flutter/material.dart';

void main() {
  //debugDefaultTargetPlatformOverride  = TargetPlatform.fuchsia;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    int r = brandColor.red;
    int g = brandColor.green;
    int b = brandColor.blue;
    Map<int, Color> map;
    map = {
      50: Color.fromRGBO(r, g, b, 0.1),
      100: Color.fromRGBO(r, g, b, 0.2),
      200: Color.fromRGBO(r, g, b, 0.3),
      300: Color.fromRGBO(r, g, b, 0.4),
      400: Color.fromRGBO(r, g, b, 0.5),
      500: Color.fromRGBO(r, g, b, 0.6),
      600: Color.fromRGBO(r, g, b, 0.7),
      700: Color.fromRGBO(r, g, b, 0.8),
      800: Color.fromRGBO(r, g, b, 0.9),
      900: Color.fromRGBO(r, g, b, 1),
    };
    return AuthProvider(
      child: MaterialApp(
        title: 'OfferHunt Buissness',
        theme: ThemeData(
          canvasColor: Colors.white,
          primarySwatch: MaterialColor(brandColor.value, map),
          appBarTheme: AppBarTheme(
            elevation: 0,
            color: Colors.transparent,
            textTheme: Theme.of(context).textTheme.copyWith(
              headline6: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black87,letterSpacing: 1,fontWeight: FontWeight.w500),
            ),
          ),
          accentColor: brandColor2,
          buttonTheme: ButtonThemeData(
            buttonColor: brandColor,
            textTheme: ButtonTextTheme.primary,
            shape: StadiumBorder(),

          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          dialogTheme: DialogTheme(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
        ),
        home: SplashScreen(),
      )
    );
  }
}