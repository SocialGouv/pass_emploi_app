import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/ignore_tracking_context_provider.dart';
import 'package:pass_emploi_app/presentation/cvm/cvm_chat_page.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_material_app.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:redux/redux.dart';

class PassEmploiApp extends StatelessWidget {
  static final routeObserver = RouteObserver<PageRoute<dynamic>>();
  final Store<AppState> _store;

  PassEmploiApp(this._store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: _store,
      child: IgnoreTrackingContextProvider(
        child: PassEmploiMaterialApp(
            scaffoldMessengerKey: snackBarKey,
            title: Strings.appName,
            navigatorObservers: [routeObserver],
            //home: RouterPage()),
            home: CvmChatPage()), //TODO-CVM
      ),
    );
  }
}
