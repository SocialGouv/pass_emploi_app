import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_actions.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/chat_page.dart';
import 'package:pass_emploi_app/pages/favoris/favoris_tabs_page.dart';
import 'package:pass_emploi_app/pages/mon_suivi_tabs_page.dart';
import 'package:pass_emploi_app/pages/profil/profil_page.dart';
import 'package:pass_emploi_app/pages/solutions_tabs_page.dart';
import 'package:pass_emploi_app/presentation/main_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/menu_item.dart' as menu;
import 'package:share_plus/share_plus.dart';

const int _indexOfMonSuiviPage = 0;
const int _indexOfChatPage = 1;
const int _indexOfSolutionsPage = 2;
const int _indexOfFavorisPage = 3;
const int _indexOfPlusPage = 4;

class MainPage extends StatefulWidget {
  final MainPageDisplayState displayState;
  final int deepLinkKey;

  MainPage({this.displayState = MainPageDisplayState.DEFAULT, this.deepLinkKey = 0})
      : super(key: ValueKey(displayState.hashCode + deepLinkKey));

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  late int _selectedIndex;
  late bool _displayMonSuiviOnRendezvousTab;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _selectedIndex = _setInitIndexPage();
    _displayMonSuiviOnRendezvousTab = widget.displayState == MainPageDisplayState.RENDEZVOUS_TAB;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      StoreProvider.of<AppState>(context).dispatch(UnsubscribeFromChatStatusAction());
    }
    if (state == AppLifecycleState.resumed) {
      StoreProvider.of<AppState>(context).dispatch(SubscribeToChatStatusAction());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MainPageViewModel>(
      converter: (store) => MainPageViewModel.create(store),
      onInit: (store) => store.dispatch(SubscribeToChatStatusAction()),
      onDispose: (store) => store.dispatch(UnsubscribeFromChatStatusAction()),
      builder: (context, viewModel) => _body(viewModel, context),
      distinct: true,
    );
  }

  Widget _body(MainPageViewModel viewModel, BuildContext context) {
    if (viewModel.share) Share.shareFilesWithResult(["path"]);
    return Scaffold(
      body: Container(
        color: AppColors.grey100,
        child: _content(_selectedIndex, viewModel),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.secondary,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          menu.MenuItem(drawableRes: Drawables.icMenuAction, label: Strings.menuMonSuivi),
          menu.MenuItem(drawableRes: Drawables.icMenuChat, label: Strings.menuChat, withBadge: viewModel.withChatBadge),
          menu.MenuItem(drawableRes: Drawables.icSearchingBar, label: Strings.menuSolutions),
          menu.MenuItem(drawableRes: Drawables.icHeart, label: Strings.menuFavoris),
          menu.MenuItem(drawableRes: Drawables.icMenuPlus, label: Strings.menuProfil),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    if (index == _indexOfMonSuiviPage) {
      context.trackEvent(EventType.ACTION_LISTE);
    }
    setState(() => _selectedIndex = index);
  }

  Widget _content(int index, MainPageViewModel viewModel) {
    switch (index) {
      case _indexOfMonSuiviPage:
        final initialTab = _displayMonSuiviOnRendezvousTab ? MonSuiviTab.RENDEZVOUS : MonSuiviTab.ACTIONS;
        _displayMonSuiviOnRendezvousTab = false;
        return MonSuiviTabPage(initialTab: initialTab, isPoleEmploiLogin: viewModel.isPoleEmploiLogin);
      case _indexOfChatPage:
        return ChatPage();
      case _indexOfSolutionsPage:
        return SolutionsTabPage();
      case _indexOfFavorisPage:
        return FavorisTabsPage(widget.displayState == MainPageDisplayState.SAVED_SEARCH ? 1 : 0);
      case _indexOfPlusPage:
        return ProfilPage();
      default:
        return MonSuiviTabPage(initialTab: MonSuiviTab.ACTIONS, isPoleEmploiLogin: viewModel.isPoleEmploiLogin);
    }
  }

  int _setInitIndexPage() {
    switch (widget.displayState) {
      case MainPageDisplayState.CHAT:
        return _indexOfChatPage;
      case MainPageDisplayState.SEARCH:
        return _indexOfSolutionsPage;
      case MainPageDisplayState.SAVED_SEARCH:
        return _indexOfFavorisPage;
      default:
        return _indexOfMonSuiviPage;
    }
  }
}
