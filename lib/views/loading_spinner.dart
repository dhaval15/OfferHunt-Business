import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../colors.dart' as colors;
import '../mixins.dart';
class LoadingSpinner extends StatelessWidget with ScreenUtilMixin{
  @override
  Widget build(BuildContext context) {
    return SpinKitRing(
      color: colors.brandColor,
      lineWidth: 3,
      size: sw(48),
    );
  }
}