import 'dart:io' as io;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/pages/entree_page.dart';
import 'package:pass_emploi_app/pages/main_page.dart';
import 'package:pass_emploi_app/pages/spash_screen_page.dart';
import 'package:pass_emploi_app/pages/tutorial_page.dart';
import 'package:pass_emploi_app/presentation/router_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/platform.dart';

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
    final platform = io.Platform.isAndroid ? Platform.ANDROID : Platform.IOS;
    return StoreConnector<AppState, RouterPageViewModel>(
      onInit: (store) => store.dispatch(BootstrapAction()),
      converter: (store) => RouterPageViewModel.create(store, platform),
      builder: (context, viewModel) => _content(viewModel),
      ignoreChange: (state) => state.deepLinkState is UsedDeepLinkState,
      onDidChange: _onDidChange,
      distinct: true,
    );
  }

  Widget _content(RouterPageViewModel viewModel) {
    switch (viewModel.routerPageDisplayState) {
      case RouterPageDisplayState.SPLASH:
        return SplashScreenPage();
      case RouterPageDisplayState.LOGIN:
        return EntreePage();
      case RouterPageDisplayState.TUTORIAL:
        return TutorialPage();
      case RouterPageDisplayState.MAIN:
        return MainPage(
          displayState: viewModel.mainPageDisplayState,
          deepLinkKey: viewModel.deepLinkKey,
        );
    }
  }

  Future<void> _onDidChange(RouterPageViewModel? oldVm, RouterPageViewModel newVm) async {
    if (newVm.routerPageDisplayState == RouterPageDisplayState.LOGIN ||
        newVm.routerPageDisplayState == RouterPageDisplayState.MAIN) {
      _removeAllScreensAboveRouterPage();
    }
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

  void _handleDeepLink(RemoteMessage message) => StoreProvider.of<AppState>(context).dispatch(DeepLinkAction(message));
}
