import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/connectivity/connectivity_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/pages/first_lauch_onboarding_page.dart';
import 'package:pass_emploi_app/pages/login_page.dart';
import 'package:pass_emploi_app/pages/main_page.dart';
import 'package:pass_emploi_app/pages/spash_screen_page.dart';
import 'package:pass_emploi_app/pages/tutorial_page.dart';
import 'package:pass_emploi_app/presentation/router_page_view_model.dart';
import 'package:pass_emploi_app/push/deep_link_factory.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/utils/platform.dart';

class RouterPage extends StatefulWidget {
  @override
  State<RouterPage> createState() => _RouterPageState();
}

/*
 * Handling of opened push notifications totally inspired from FlutterFire documentation
 * [https://firebase.flutter.dev/docs/messaging/notifications].
 */
class _RouterPageState extends State<RouterPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _handleOpeningApplication();
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
      StoreProvider.of<AppState>(context).dispatch(UnsubscribeFromConnectivityUpdatesAction());
    }
    if (state == AppLifecycleState.resumed) {
      StoreProvider.of<AppState>(context).dispatch(SubscribeToConnectivityUpdatesAction());
    }
  }

  @override
  Widget build(BuildContext context) {
    final platform = PlatformUtils.getPlatform;
    return StoreConnector<AppState, RouterPageViewModel>(
      onInit: (store) {
        store.dispatch(BootstrapAction());
        store.dispatch(SubscribeToConnectivityUpdatesAction());
      },
      converter: (store) => RouterPageViewModel.create(store, platform),
      builder: (context, viewModel) => _content(viewModel),
      ignoreChange: (state) => state.deepLinkState is UsedDeepLinkState,
      onWillChange: _onWillChange,
      onDidChange: _onDidChange,
      distinct: true,
    );
  }

  Widget _content(RouterPageViewModel viewModel) {
    switch (viewModel.routerPageDisplayState) {
      case RouterPageDisplayState.SPLASH:
        return SplashScreenPage();
      case RouterPageDisplayState.ONBOARDING:
        return FirstLaunchOnboardingPage();
      case RouterPageDisplayState.LOGIN:
        return LoginPage();
      case RouterPageDisplayState.TUTORIAL:
        return TutorialPage();
      case RouterPageDisplayState.MAIN:
        return MainPage(
          displayState: viewModel.mainPageDisplayState,
          deepLinkKey: viewModel.deepLinkKey,
        );
    }
  }

  Future<void> _onWillChange(RouterPageViewModel? oldVm, RouterPageViewModel newVm) async {
    if (newVm.routerPageDisplayState == RouterPageDisplayState.LOGIN ||
        newVm.routerPageDisplayState == RouterPageDisplayState.MAIN) {
      _removeAllScreensAboveRouterPage();
    }
  }

  Future<void> _onDidChange(RouterPageViewModel? oldVm, RouterPageViewModel newVm) async {
    if (newVm.storeUrl != null) {
      launchExternalUrl(newVm.storeUrl!);
      newVm.onAppStoreOpened();
    }
  }

  void _removeAllScreensAboveRouterPage() {
    if (Navigator.canPop(context)) {
      Navigator.popUntil(context, (route) => route.settings.name == Navigator.defaultRouteName);
    }
  }

  Future<void> _handleOpeningApplication() async {
    await _handleStoppedApplicationOpenedFromPushNotification();
    _handleBackgroundApplicationOpenedFromPushNotification();
  }

  Future<void> _handleStoppedApplicationOpenedFromPushNotification() async {
    final RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) _handleDeepLink(initialMessage);
  }

  void _handleBackgroundApplicationOpenedFromPushNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen(_handleDeepLink);
  }

  void _handleDeepLink(RemoteMessage message) {
    final type = message.getType();
    if (type != null) {
      PassEmploiMatomoTracker.instance.trackEvent(
        eventCategory: AnalyticsEventNames.pushNotificationEventCategory,
        action: AnalyticsEventNames.pushNotificationOpenedAction,
        eventName: type,
      );
    }
    final deepLink = DeepLinkFactory.fromJson(message.data);
    if (deepLink != null) {
      StoreProvider.of<AppState>(context).dispatch(
        HandleDeepLinkAction(
          deepLink,
          DeepLinkOrigin.pushNotification,
        ),
      );
    }
  }
}
