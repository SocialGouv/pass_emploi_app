import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/pages/entree_page.dart';
import 'package:pass_emploi_app/pages/main_page.dart';
import 'package:pass_emploi_app/pages/spash_screen_page.dart';
import 'package:pass_emploi_app/presentation/router_page_view_model.dart';
import 'package:pass_emploi_app/redux/actions/deep_link_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/deep_link_state.dart';

class RouterPage extends StatefulWidget {
  @override
  State<RouterPage> createState() => _RouterPageState();
}

/*
 * Handling of opened push notifications totally inspired from FlutterFire documentation
 * [https://firebase.flutter.dev/docs/messaging/notifications].
 */
class _RouterPageState extends State<RouterPage> {
  @override
  void initState() {
    super.initState();
    _handleOpeningApplication();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RouterPageViewModel>(
      onInit: (store) => store.dispatch(BootstrapAction()),
      converter: (store) => RouterPageViewModel.create(store),
      builder: (context, viewModel) => _content(viewModel),
      ignoreChange: (state) => state.deepLinkState.deepLink == DeepLink.USED,
      onDidChange: (previousViewModel, viewModel) {
        if (viewModel.routerPageDisplayState == RouterPageDisplayState.LOGIN ||
            viewModel.routerPageDisplayState == RouterPageDisplayState.MAIN) {
          _removeAllScreensAboveRouterPage();
        }
      },
      distinct: true,
    );
  }

  Widget _content(RouterPageViewModel viewModel) {
    switch (viewModel.routerPageDisplayState) {
      case RouterPageDisplayState.SPLASH:
        return SplashScreenPage();
      case RouterPageDisplayState.LOGIN:
        return EntreePage();
      case RouterPageDisplayState.MAIN:
        return MainPage(
          displayState: viewModel.mainPageDisplayState,
          deepLinkKey: viewModel.deepLinkKey,
        );
    }
  }

  void _removeAllScreensAboveRouterPage() {
    if (Navigator.canPop(context)) {
      Navigator.popUntil(context, (route) => route.settings.name?.contains("/") ?? false);
    }
  }

  Future<void> _handleOpeningApplication() async {
    await _handleStoppedApplicationOpenedFromPushNotification();
    _handleBackgroundApplicationOpenedFromPushNotification();
  }

  Future<void> _handleStoppedApplicationOpenedFromPushNotification() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) _handleDeepLink(initialMessage);
  }

  void _handleBackgroundApplicationOpenedFromPushNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen(_handleDeepLink);
  }

  void _handleDeepLink(RemoteMessage message) => StoreProvider.of<AppState>(context).dispatch(DeepLinkAction(message));
}
