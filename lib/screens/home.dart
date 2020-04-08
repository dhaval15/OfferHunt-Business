import 'package:offerhuntbusiness/api/api.dart';
import 'package:offerhuntbusiness/models/models.dart';
import 'package:offerhuntbusiness/screens/settings.dart';
import 'package:offerhuntbusiness/screens/shop_list.dart';
import 'package:offerhuntbusiness/views/app_title.dart';

import '../colors.dart';
import 'package:flutter/material.dart';

import '../mixins.dart';
import 'add_shop.dart';

class HomeScreen extends StatefulWidget {
  static final builder = MaterialPageRoute(builder: (context) => HomeScreen());

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('OfferHunt Business'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: _buildBody(),
        ),
      ),
      floatingActionButton: _currentIndex != 2
          ? FloatingActionButton(
              elevation: 2,
              onPressed: _onFab,
              child: Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        onTap: (index) {
          setState(
            () {
              _currentIndex = index;
            },
          );
        },
        currentIndex: _currentIndex,
      ),
    );
  }

  Widget _buildBody() {
    if (_currentIndex == 0)
      return OfferList();
    else if (_currentIndex == 1)
      return ShopList();
    else
      return SettingsScreen();
  }

  void _onFab() {
    if (_currentIndex == 0) {
      final owner = AuthProvider.of(context).currentOwner;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddShop(
                shop: Shop.ofOwner(owner),
              )));
    } else if (_currentIndex == 1) {
      final owner = AuthProvider.of(context).currentOwner;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddShop(
                shop: Shop.ofOwner(owner),
              )));
    }
  }
}

class BottomItem extends StatelessWidget with ScreenUtilMixin {
  final bool isSelected;
  final IconData icon;
  final String label;

  const BottomItem({this.isSelected, this.icon, this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(
          icon,
          color: brandColor,
        ),
        Container(
          height: sh(2),
          width: sw(10),
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: isSelected ? brandColor2 : Colors.transparent,
          ),
        ),
      ],
    );
  }
}

class NavigationBar extends StatelessWidget with ScreenUtilMixin {
  final int currentIndex;

  final Function(int index) onTap;

  const NavigationBar({this.onTap, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      unselectedFontSize: sf(16),
      elevation: 0,
      iconSize: sw(32),
      type: BottomNavigationBarType.fixed,
      onTap: onTap,
      selectedLabelStyle: TextStyle(
        fontSize: sf(16),
        fontWeight: FontWeight.w500,
        color: brandColor,
      ),
      items: [
        bottomItem(Icons.home, 'Shops'),
        bottomItem(Icons.home, 'Offers'),
        bottomItem(Icons.account_circle, 'Account'),
      ],
    );
  }

  BottomNavigationBarItem bottomItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: BottomItem(
        isSelected: false,
        icon: icon,
        label: label,
      ),
      activeIcon: BottomItem(
        isSelected: true,
        icon: icon,
        label: label,
      ),
      //title: verticalGap(12),
      title: Text(label, style: TextStyle(color: brandColor)),
    );
  }
}
