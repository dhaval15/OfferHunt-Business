
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin TextStyleMixin<T extends StatefulWidget> on State<T>{
  TextTheme get _theme => Theme.of(context).textTheme;
  TextStyle get headline1 => _theme.headline1;
  TextStyle get headline2 => _theme.headline2;
  TextStyle get headline3 => _theme.headline3;
  TextStyle get headline4 => _theme.headline4;
  TextStyle get headline5 => _theme.headline5;
  TextStyle get headline6 => _theme.headline6;
  TextStyle get bodyText1 => _theme.bodyText1;
  TextStyle get bodyText2 => _theme.bodyText2;
  TextStyle get subtitle1 => _theme.subtitle1;
  TextStyle get subtitle2 => _theme.subtitle2;
  TextStyle get button => _theme.button;
  TextStyle get overline => _theme.overline;
  TextStyle get caption => _theme.caption;
}

mixin ScreenUtilMixin on StatelessWidget{
  num sh(num height) => ScreenUtil().setHeight(height);
  num sw(num width) => ScreenUtil().setWidth(width);
  num sf(num fontSize) => ScreenUtil().setSp(fontSize);
  Size ss(num width,num height) => Size(sw(width), sh(height));
  SizedBox verticalGap(num height) => SizedBox(height: sh(height));
  SizedBox horizontalGap(num width) => SizedBox(width: sw(width));
}

mixin ScreenUtilStateMixin<T extends StatefulWidget> on State<T>{
  num sh(num height) => ScreenUtil().setHeight(height);
  num sw(num width) => ScreenUtil().setWidth(width);
  num sf(num fontSize) => ScreenUtil().setSp(fontSize);
  Size ss(num width,num height) => Size(sw(width), sh(height));
  SizedBox verticalGap(num height) => SizedBox(height: sh(height));
  SizedBox horizontalGap(num width) => SizedBox(width: sw(width));
}