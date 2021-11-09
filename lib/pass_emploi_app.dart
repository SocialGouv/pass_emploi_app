import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics.dart';
import 'package:pass_emploi_app/pages/offre_emploi_list_page.dart';
import 'package:pass_emploi_app/pages/router_page.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

import 'analytics/analytics_observer.dart';

class PassEmploiApp extends StatelessWidget {
  final Store<AppState> _store;
  final Analytics analytics;

  PassEmploiApp(this._store, this.analytics);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: _store,
      child: MaterialApp(
        title: Strings.appName,
        theme: ThemeData(
            primarySwatch: Colors.indigo,
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            )),
        home: RouterPage(),
        navigatorObservers: [
          AnalyticsObserver(analytics),
        ],
      ),
    );
  }
}