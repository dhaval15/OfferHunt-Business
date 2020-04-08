import '../colors.dart';
import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'OfferHunt Business',
      style: Theme.of(context).textTheme.headline5,
    );
  }
}
