import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offerhuntbusiness/mixins.dart';

import '../colors.dart';
import 'package:flutter/material.dart';
import '../api/auth.dart';
import '../utils/utils.dart';
import '../views/views.dart';
import 'home.dart';
import 'auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with ScreenUtilStateMixin {
  @override
  void initState() {
    super.initState();
    lazyExecute(Duration(seconds: 1), () async {
      final provider = AuthProvider.of(context);
      await provider.init();
      final route = provider.currentOwner != null
          ? HomeScreen.builder
          : provider.currentUser != null
              ? AuthScreen.builder(status: PhoneAuthStatus.details)
              : AuthScreen.builder();
      Navigator.of(context).pushReplacement(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(size);
    ScreenUtil.init(context, width: size.width, height: size.height);
    return Scaffold(
      backgroundColor: brandColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Logo(),
              verticalGap(12),
              AppTitle(),
            ],
          ),
        ),
      ),
    );
  }
}
