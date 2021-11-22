import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/chat_page.dart';
import 'package:pass_emploi_app/pages/home_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_router_page.dart';
import 'package:pass_emploi_app/pages/rendezvous_list_page.dart';
import 'package:pass_emploi_app/pages/user_action_list_page.dart';
import 'package:pass_emploi_app/presentation/main_page_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/menu_item.dart';

class MainPage extends StatefulWidget {
  final String userId;
  final MainPageDisplayState displayState;
  final int deepLinkKey;

  MainPage(this.userId, {this.displayState = MainPageDisplayState.DEFAULT, this.deepLinkKey = 0})
      : super(key: ValueKey(displayState.hashCode + deepLinkKey));

  @override
  _MainPageState createState() => _MainPageState(_getIndexOfDisplayState(displayState));

  // TODO-75  : utiliser les même int ?
  int _getIndexOfDisplayState(MainPageDisplayState displayState) {
    switch (displayState) {
      case MainPageDisplayState.DEFAULT:
        return 0;
      case MainPageDisplayState.ACTIONS_LIST:
        return 1;
      case MainPageDisplayState.RENDEZVOUS_LIST:
        return 3;
      case MainPageDisplayState.CHAT:
        return 2;
    }
  }
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex;

  _MainPageState(this._selectedIndex);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MainPageViewModel>(
      converter: (store) => MainPageViewModel.create(store),
      builder: (context, viewModel) => _body(viewModel),
      distinct: true,
    );
  }

  Widget _body(MainPageViewModel viewModel) {
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
          MenuItem(drawableRes: Drawables.icMenuChat, label: Strings.menuChat, withBadge: viewModel.withChatBadge),
          MenuItem(drawableRes: Drawables.icMenuRendezvous, label: Strings.menuRendezvous),
          MenuItem(drawableRes: Drawables.icSearchingBar, label: Strings.menuSolutions),
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
      case 4:
        return OffreEmploiRouterPage();
      default:
        return HomePage(widget.userId);
    }
  }
}
