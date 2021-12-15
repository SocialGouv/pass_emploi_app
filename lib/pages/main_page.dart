import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/chat_page.dart';
import 'package:pass_emploi_app/pages/favoris_page.dart';
import 'package:pass_emploi_app/pages/solutions_tabs_page.dart';
import 'package:pass_emploi_app/presentation/main_page_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/menu_item.dart';

import 'mon_suivi_tabs_page.dart';

const int _indexOfMonSuiviPage = 0;
const int _indexOfChatPage = 1;
const int _indexOfSolutionsPage = 2;
const int _indexOfFavorisPage = 3;

class MainPage extends StatefulWidget {
  final MainPageDisplayState displayState;
  final int deepLinkKey;

  MainPage({this.displayState = MainPageDisplayState.DEFAULT, this.deepLinkKey = 0})
      : super(key: ValueKey(displayState.hashCode + deepLinkKey));

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex;
  late bool _displayMonSuiviOnRendezvousTab;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.displayState == MainPageDisplayState.CHAT ? _indexOfChatPage : _indexOfMonSuiviPage;
    _displayMonSuiviOnRendezvousTab = widget.displayState == MainPageDisplayState.RENDEZVOUS_TAB;
  }

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
          MenuItem(drawableRes: Drawables.icMenuAction, label: Strings.menuMonSuivi),
          MenuItem(drawableRes: Drawables.icMenuChat, label: Strings.menuChat, withBadge: viewModel.withChatBadge),
          MenuItem(drawableRes: Drawables.icSearchingBar, label: Strings.menuSolutions),
          MenuItem(drawableRes: Drawables.icHeart, label: Strings.menuFavoris),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  Widget _content(int index) {
    switch (index) {
      case _indexOfMonSuiviPage:
        final initialTab = _displayMonSuiviOnRendezvousTab ? MonSuiviTab.RENDEZVOUS : MonSuiviTab.ACTIONS;
        _displayMonSuiviOnRendezvousTab = false;
        return MonSuiviTabPage(initialTab: initialTab);
      case _indexOfChatPage:
        return ChatPage();
      case _indexOfSolutionsPage:
        return SolutionsTabPage();
      case _indexOfFavorisPage:
        return FavorisPage();
      default:
        return MonSuiviTabPage(initialTab: MonSuiviTab.ACTIONS);
    }
  }
}
