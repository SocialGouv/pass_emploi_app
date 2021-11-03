import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/menu_item.dart';

class MainPage extends StatefulWidget {
  MainPage._();

  static MaterialPageRoute materialPageRoute() {
    return MaterialPageRoute(builder: (context) => MainPage._(), settings: AnalyticsRouteSettings.home());
  }

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.lightBlue,
        child: Center(
          child: Text("$_selectedIndex"),
        ),
      ),
      bottomNavigationBar: Container(
        height: Dimens.bottomNavigationBarHeight,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: <BottomNavigationBarItem>[
            MenuItem(drawableRes: Drawables.icMenuHome, label: Strings.menuHome),
            MenuItem(drawableRes: Drawables.icMenuAction, label: Strings.menuActions),
            MenuItem(drawableRes: Drawables.icMenuChat, label: Strings.menuChat),
            MenuItem(drawableRes: Drawables.icMenuRendezvous, label: Strings.menuRendezvous),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
