import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/chat_page.dart';
import 'package:pass_emploi_app/pages/home_page.dart';
import 'package:pass_emploi_app/pages/rendezvous_list_page.dart';
import 'package:pass_emploi_app/pages/solutions_tabs_page.dart';
import 'package:pass_emploi_app/pages/user_action_list_page.dart';
import 'package:pass_emploi_app/presentation/main_page_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/menu_item.dart';

const int _indexOfHomePage = 0;
const int _indexOfUserActionListPage = 1;
const int _indexOfChatPage = 2;
const int _indexOfRendezvousListPage = 3;
const int _indexOfSolutionsPage = 4;

class MainPage extends StatefulWidget {
  final String userId;
  final MainPageDisplayState displayState;
  final int deepLinkKey;

  MainPage(this.userId, {this.displayState = MainPageDisplayState.DEFAULT, this.deepLinkKey = 0})
      : super(key: ValueKey(displayState.hashCode + deepLinkKey));

  @override
  _MainPageState createState() => _MainPageState(_getIndexOfDisplayState(displayState));

  int _getIndexOfDisplayState(MainPageDisplayState displayState) {
    switch (displayState) {
      case MainPageDisplayState.DEFAULT:
        return _indexOfHomePage;
      case MainPageDisplayState.ACTIONS_LIST:
        return _indexOfUserActionListPage;
      case MainPageDisplayState.CHAT:
        return _indexOfChatPage;
      case MainPageDisplayState.RENDEZVOUS_LIST:
        return _indexOfRendezvousListPage;
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
      case _indexOfUserActionListPage:
        return UserActionListPage(widget.userId);
      case _indexOfChatPage:
        return ChatPage();
      case _indexOfRendezvousListPage:
        return RendezvousListPage();
      case _indexOfSolutionsPage:
        return SolutionsTabPage();
      default:
        return HomePage(widget.userId);
    }
  }
}
