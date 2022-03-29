import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/cej_information_page.dart';
import 'package:pass_emploi_app/pages/choix_organisme_page.dart';
import 'package:pass_emploi_app/pages/credentials_page.dart';
import 'package:pass_emploi_app/pages/login_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_list_page.dart';
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
          onGenerateRoute: (settings) {
            if (settings.name == RouterPage.routeName) {
              return MaterialPageRoute(builder: (context) => RouterPage());
            } else if (settings.name == CejInformationPage.routeName) {
              return MaterialPageRoute(builder: (context) => CejInformationPage());
            } else if (settings.name == CredentialsPage.routeName) {
              return MaterialPageRoute(builder: (context) => CredentialsPage());
            } else if (settings.name == ChoixOrganismePage.routeName) {
              return MaterialPageRoute(builder: (context) => ChoixOrganismePage());
            } else if (settings.name == LoginPage.routeName) {
              return MaterialPageRoute(builder: (context) => LoginPage());
            } else if (settings.name == OffreEmploiListPage.routeName) {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => OffreEmploiListPage(
                  onlyAlternance: args["onlyAlternance"] as bool,
                  fromSavedSearch: (args["fromSavedSearch"] ?? false) as bool,
                ),
                settings: settings,
              );
            } else {
              return null;
            }
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
