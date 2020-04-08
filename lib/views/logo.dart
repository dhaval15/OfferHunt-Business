import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Logo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'icon',
      child: Icon(
        Icons.apps,
        size: ScreenUtil().setWidth(128),
      ),
    );
  }

}