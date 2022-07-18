import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/router_page.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/theme.dart';
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
      child: MaterialApp(
        scaffoldMessengerKey: snackbarKey,
        title: Strings.appName,
        theme: PassEmploiTheme.data,
        home: RouterPage(),
        navigatorObservers: [routeObserver],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'),
          Locale('fr'),
        ],
      ),
    );
  }
}
