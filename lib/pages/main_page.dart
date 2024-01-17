import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_actions.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_page.dart';
import 'package:pass_emploi_app/pages/chat_page.dart';
import 'package:pass_emploi_app/pages/events_tab_page.dart';
import 'package:pass_emploi_app/pages/mon_suivi_milo_page.dart';
import 'package:pass_emploi_app/pages/mon_suivi_tabs_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_evenement_emploi_page.dart';
import 'package:pass_emploi_app/pages/solutions_tabs_page.dart';
import 'package:pass_emploi_app/presentation/main_page_view_model.dart';
import 'package:pass_emploi_app/presentation/mon_suivi_tabs_view_model.dart';
import 'package:pass_emploi_app/presentation/solutions_tabs_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/menu_item.dart' as menu;
import 'package:pass_emploi_app/widgets/pass_emploi_material_app.dart';
import 'package:pass_emploi_app/widgets/snack_bar/rating_snack_bar.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class MainPage extends StatefulWidget {
  final MainPageDisplayState displayState;
  final int deepLinkKey;

  MainPage({this.displayState = MainPageDisplayState.DEFAULT, this.deepLinkKey = 0})
      : super(key: ValueKey(displayState.hashCode + deepLinkKey));

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> with WidgetsBindingObserver {
  static const _indexNotInitialized = -1;

  bool _deepLinkHandled = false;
  int _selectedIndex = _indexNotInitialized;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    _setInitIndexPage(viewModel);
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
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.grey800,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: viewModel.tabs.map((e) => e.asMenuItem(viewModel)).toList(),
          currentIndex: _selectedIndex,
          onTap: (index) => _onItemTapped(index, viewModel),
        ),
      ),
    );
  }

  void _onItemTapped(int index, MainPageViewModel viewModel) {
    setState(() => _selectedIndex = index);
  }

  Widget _content(int index, MainPageViewModel viewModel) {
    return switch (viewModel.tabs[index]) {
      MainTab.accueil => AccueilPage(),
      MainTab.monSuivi => _monSuiviPage(viewModel),
      MainTab.chat => ChatPage(),
      MainTab.solutions => _solutionsPage(viewModel),
      MainTab.evenements => _evenementsPage(viewModel),
    };
  }

  Widget _monSuiviPage(MainPageViewModel viewModel) {
    if (viewModel.loginMode?.isMiLo() == true) return MonSuiviMiloPage();
    final initialTab = !_deepLinkHandled ? _initialMonSuiviTab() : null;
    _deepLinkHandled = true;
    return MonSuiviTabPage(initialTab);
  }

  Widget _solutionsPage(MainPageViewModel viewModel) {
    final initialTab = !_deepLinkHandled ? _initialSolutionsTab() : null;
    _deepLinkHandled = true;
    return SolutionsTabPage(initialTab: initialTab);
  }

  Widget _evenementsPage(MainPageViewModel viewModel) {
    if (viewModel.loginMode?.isMiLo() == true) return EventsTabPage();
    return RechercheEvenementEmploiPage.withPrimaryAppBar();
  }

  MonSuiviTab? _initialMonSuiviTab() {
    switch (widget.displayState) {
      case MainPageDisplayState.AGENDA_TAB:
        return MonSuiviTab.AGENDA;
      case MainPageDisplayState.ACTIONS_TAB:
        return MonSuiviTab.ACTIONS;
      case MainPageDisplayState.RENDEZVOUS_TAB:
        return MonSuiviTab.RENDEZVOUS;
      default:
        return null;
    }
  }

  SolutionsTab? _initialSolutionsTab() {
    switch (widget.displayState) {
      case MainPageDisplayState.OUTILS:
        return SolutionsTab.outils;
      default:
        return null;
    }
  }

  void _setInitIndexPage(MainPageViewModel viewModel) {
    if (_selectedIndex != _indexNotInitialized) return;
    late int initialIndex;
    switch (widget.displayState) {
      case MainPageDisplayState.DEFAULT:
      case MainPageDisplayState.ACTUALISATION_PE:
      case MainPageDisplayState.FAVORIS:
      case MainPageDisplayState.ALERTE:
      case MainPageDisplayState.ALERTES:
        initialIndex = 0;
        break;
      case MainPageDisplayState.AGENDA_TAB:
      case MainPageDisplayState.ACTIONS_TAB:
      case MainPageDisplayState.RENDEZVOUS_TAB:
        initialIndex = viewModel.tabs.indexOf(MainTab.monSuivi);
        break;
      case MainPageDisplayState.CHAT:
        initialIndex = viewModel.tabs.indexOf(MainTab.chat);
        break;
      case MainPageDisplayState.OUTILS:
      case MainPageDisplayState.RECHERCHE:
        initialIndex = viewModel.tabs.indexOf(MainTab.solutions);
        break;
      case MainPageDisplayState.EVENT_LIST:
        initialIndex = viewModel.tabs.indexOf(MainTab.evenements);
        break;
    }
    _selectedIndex = initialIndex != -1 ? initialIndex : 0;
  }
}

class _ModeDemoWrapper extends StatelessWidget {
  final Widget child;

  const _ModeDemoWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final isDemo = store.state.demoState;
    if (!isDemo) return child;
    return Scaffold(
      appBar: ModeDemoAppBar(),
      body: PassEmploiMaterialApp(
        scaffoldMessengerKey: modeDemoSnackBarKey,
        debugShowCheckedModeBanner: false,
        builder: (context, materialAppChild) => MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: materialAppChild ?? Container(),
        ),
        // required to avoid automatic top scrolling when keyboard is displayed
        useInheritedMediaQuery: true,
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
            icon: AppIcons.open_in_new_rounded,
            heightPadding: 8,
            iconSize: Dimens.icon_size_base,
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

extension _MainTab on MainTab {
  menu.MenuItem asMenuItem(MainPageViewModel viewModel) {
    switch (this) {
      case MainTab.accueil:
        return menu.MenuItem(
          defaultIcon: AppIcons.home_rounded,
          inactiveIcon: AppIcons.home_outlined,
          label: Strings.menuAccueil,
        );
      case MainTab.monSuivi:
        return menu.MenuItem(
          defaultIcon: AppIcons.checklist_rounded,
          inactiveIcon: AppIcons.rule_rounded,
          label: Strings.menuMonSuivi,
        );
      case MainTab.chat:
        return menu.MenuItem(
          defaultIcon: AppIcons.chat_rounded,
          inactiveIcon: AppIcons.chat_outlined,
          label: Strings.menuChat,
          withBadge: viewModel.withChatBadge,
        );
      case MainTab.solutions:
        return menu.MenuItem(
          defaultIcon: AppIcons.pageview_rounded,
          inactiveIcon: AppIcons.pageview_outlined,
          label: Strings.menuSolutions,
        );
      case MainTab.evenements:
        return menu.MenuItem(
          defaultIcon: AppIcons.today_rounded,
          inactiveIcon: AppIcons.today_outlined,
          label: Strings.menuEvenements,
        );
    }
  }
}
