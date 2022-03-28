import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/cej_information_page.dart';
import 'package:pass_emploi_app/pages/choix_organisme_page.dart';
import 'package:pass_emploi_app/pages/credentials_page.dart';
import 'package:pass_emploi_app/pages/login_page.dart';
import 'package:pass_emploi_app/pages/router_page.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/theme.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:redux/redux.dart';

class PassEmploiApp extends StatelessWidget {
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
          initialRoute: RouterPage.routeName,
          routes: {
            RouterPage.routeName: (context) => RouterPage(),
            CejInformationPage.routeName: (context) => CejInformationPage(),
            CredentialsPage.routeName: (context) => CredentialsPage(),
            ChoixOrganismePage.routeName: (context) => ChoixOrganismePage(),
            LoginPage.routeName: (context) => LoginPage(),
          },
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en'),
            Locale('fr'),
          ]),
    );
  }
}
