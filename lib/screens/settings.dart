import 'package:flutter/material.dart';
import 'package:offerhuntbusiness/api/api.dart';
import 'package:offerhuntbusiness/colors.dart';
import 'package:offerhuntbusiness/views/views.dart';

import '../pairs.dart';
import 'auth.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    size: 128,
                    color: brandColor,
                  ),
                  Text(
                    AuthProvider.of(context).currentOwner.userName,
                    style: TextStyle(color: brandColor, fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                ListTile(title: Text('Edit Profile')),
                ListTile(
                  title: Text('Logout'),
                  onTap: () => _logout(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    final duo = await showDialog<Duo<ProgressState, dynamic>>(
        context: context,
        builder: (context) => ProgressDialog(
              task: () async {
                await AuthProvider.of(context).logout();
              },
              startTitle: 'Log Out',
              runningTitle: 'Logging Out',
              completedTitle: 'Successfully Logged Out',
              errorTitle: 'Something went wrong',
              button: 'Logout',
            ));
    if (duo.first == ProgressState.completed)
      Navigator.of(context).pushReplacement(AuthScreen.builder());
  }
}
