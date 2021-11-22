import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/login_page.dart';
import 'package:pass_emploi_app/pages/main_page.dart';
import 'package:pass_emploi_app/pages/spash_screen_page.dart';
import 'package:pass_emploi_app/presentation/router_page_view_model.dart';
import 'package:pass_emploi_app/redux/actions/deep_link_action.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

class RouterPage extends StatefulWidget {
  @override
  State<RouterPage> createState() => _RouterPageState();
}

/*
 * Handling of opened push notification strongly inspired from FlutterFire documentation
 * [https://firebase.flutter.dev/docs/messaging/notifications].
 */
class _RouterPageState extends State<RouterPage> {
  @override
  void initState() {
    super.initState();
    _setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RouterPageViewModel>(
      onInit: (store) => store.dispatch(BootstrapAction()),
      converter: (store) => RouterPageViewModel.create(store),
      builder: (context, viewModel) => _content(viewModel),
      distinct: true,
    );
  }

  Widget _content(RouterPageViewModel viewModel) {
    switch (viewModel.routerPageDisplayState) {
      case RouterPageDisplayState.SPLASH:
        return SplashScreenPage();
      case RouterPageDisplayState.LOGIN:
        return LoginPage();
      case RouterPageDisplayState.MAIN:
        return MainPage(
          viewModel.userId,
          displayState: viewModel.mainPageDisplayState,
          deepLinkKey: viewModel.deepLinkKey,
        );
    }
  }

  //TODO-75 DOC
  Future<void> _setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) _handleMessage(initialMessage);

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) => StoreProvider.of<AppState>(context).dispatch(DeepLinkAction(message));
}
