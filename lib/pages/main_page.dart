import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_actions.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/chat_page.dart';
import 'package:pass_emploi_app/pages/favoris/favoris_tabs_page.dart';
import 'package:pass_emploi_app/pages/mon_suivi_tabs_page.dart';
import 'package:pass_emploi_app/pages/solutions_tabs_page.dart';
import 'package:pass_emploi_app/presentation/main_page_view_model.dart';
import 'package:pass_emploi_app/presentation/mon_suivi_view_model.dart';
import 'package:pass_emploi_app/presentation/solutions_tabs_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/menu_item.dart' as menu;
import 'package:pass_emploi_app/widgets/snack_bar/rating_snack_bar.dart';

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

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  bool _deepLinkHandled = false;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _selectedIndex = _setInitIndexPage();
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
      onInitialBuild: (viewModel) {
        if (widget.displayState == MainPageDisplayState.ACTUALISATION_PE) {
          viewModel.resetDeeplink();
          _showActualisationPeDialog(viewModel.actualisationPoleEmploiUrl);
        }
      },
      onInit: (store) => store.dispatch(SubscribeToChatStatusAction()),
      onDispose: (store) => store.dispatch(UnsubscribeFromChatStatusAction()),
      onDidChange: (oldViewModel, newViewModel) {
        if (newViewModel.showRating) ratingSnackBar(context);
      },
      builder: (context, viewModel) => _body(viewModel, context),
      distinct: true,
    );
  }

  void _showActualisationPeDialog(String actualisationPoleEmploiUrl) {
    showDialog(
      context: context,
      builder: (context) => _PopUpActualisationPe(actualisationPoleEmploiUrl),
    );
  }

  Widget _body(MainPageViewModel viewModel, BuildContext context) {
    return _ModeDemoWrapper(
      child: Scaffold(
        body: Container(
          color: AppColors.grey100,
          child: _content(_selectedIndex, viewModel),
        ),
        bottomNavigationBar: BottomNavigationBar(
          // Required to avoid having a disproportionate NavBar height
          selectedFontSize: FontSizes.extraSmall,
          unselectedFontSize: FontSizes.extraSmall,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.secondary,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: <BottomNavigationBarItem>[
            menu.MenuItem(
              drawableRes: Drawables.icMenuAction,
              label: Strings.menuMonSuivi,
            ),
            menu.MenuItem(
              drawableRes: Drawables.icMenuChat,
              label: Strings.menuChat,
              withBadge: viewModel.withChatBadge,
            ),
            menu.MenuItem(
              drawableRes: Drawables.icSearchingBar,
              label: Strings.menuSolutions,
            ),
            menu.MenuItem(
              drawableRes: Drawables.icHeart,
              label: Strings.menuFavoris,
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) => _onItemTapped(index, context),
        ),
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
        final initialTab = !_deepLinkHandled ? _initialMonSuiviTab() : null;
        _deepLinkHandled = true;
        return MonSuiviTabPage(initialTab);
      case _indexOfChatPage:
        return ChatPage();
      case _indexOfSolutionsPage:
        final initialTab = !_deepLinkHandled ? _initialSolutionTab(viewModel) : null;
        _deepLinkHandled = true;
        return SolutionsTabPage(initialTab);
      case _indexOfFavorisPage:
        return FavorisTabsPage(widget.displayState == MainPageDisplayState.SAVED_SEARCH ? 1 : 0);
      default:
        return MonSuiviTabPage();
    }
  }

  MonSuiviTab? _initialMonSuiviTab() {
    switch (widget.displayState) {
      case MainPageDisplayState.ACTIONS_TAB:
        return MonSuiviTab.ACTIONS;
      case MainPageDisplayState.RENDEZVOUS_TAB:
        return MonSuiviTab.RENDEZVOUS;
      default:
        return null;
    }
  }

  SolutionsTab? _initialSolutionTab(MainPageViewModel viewModel) {
    switch (widget.displayState) {
      case MainPageDisplayState.EVENT_LIST:
        viewModel.resetDeeplink();
        return SolutionsTab.events;
      default:
        return null;
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
      case MainPageDisplayState.EVENT_LIST:
        return _indexOfSolutionsPage;
      default:
        return _indexOfMonSuiviPage;
    }
  }
}

class _ModeDemoWrapper extends StatelessWidget {
  final Widget child;
  const _ModeDemoWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final isDemo = store.state.demoState;
    if (!isDemo) return child;
    return Scaffold(
      appBar: ModeDemoAppBar(),
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: child,
      ),
    );
  }
}

class _PopUpActualisationPe extends StatelessWidget {
  final String actualisationPoleEmploiUrl;

  _PopUpActualisationPe(this.actualisationPoleEmploiUrl);

  @override
  Widget build(BuildContext context) {
    const double fontSize = 16.0;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      contentPadding: EdgeInsets.all(Margins.spacing_l),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Strings.actualisationPePopUpTitle, style: TextStyles.textMBold, textAlign: TextAlign.center),
          SizedBox(height: Margins.spacing_base),
          Text(Strings.actualisationPePopUpSubtitle, style: TextStyles.textBaseRegular, textAlign: TextAlign.center),
          SizedBox(height: Margins.spacing_l),
          PrimaryActionButton(
            label: Strings.actualisationPePopUpPrimaryButton,
            drawableRes: Drawables.icLaunch,
            heightPadding: 8,
            iconSize: 16.0,
            fontSize: fontSize,
            onPressed: () => _onActualisationPressed(context),
          ),
          SizedBox(height: Margins.spacing_base),
          SecondaryButton(
            label: Strings.actualisationPePopUpSecondaryButton,
            onPressed: () => Navigator.pop(context),
            fontSize: fontSize,
          ),
        ],
      ),
    );
  }

  void _onActualisationPressed(BuildContext context) {
    Navigator.pop(context);
    PassEmploiMatomoTracker.instance.trackOutlink(actualisationPoleEmploiUrl);
    launchExternalUrl(actualisationPoleEmploiUrl);
  }
}
