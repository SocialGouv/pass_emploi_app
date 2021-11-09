import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/pages/chat_page.dart';
import 'package:pass_emploi_app/pages/home_page.dart';
import 'package:pass_emploi_app/pages/rendezvous_list_page.dart';
import 'package:pass_emploi_app/pages/user_action_list_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/menu_item.dart';

class MainPage extends StatefulWidget {
  final String userId;

  MainPage._(this.userId);

  static MaterialPageRoute materialPageRoute(String userId) {
    return MaterialPageRoute(builder: (context) => MainPage._(userId), settings: AnalyticsRouteSettings.main());
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
        child: _content(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _content(int index) {
    switch (index) {
      case 0:
        return HomePage(widget.userId);
      case 1:
        return UserActionListPage(widget.userId);
      case 2:
        return ChatPage();
      case 3:
        return RendezvousListPage();
      default:
        return HomePage(widget.userId);
    }
  }
}
