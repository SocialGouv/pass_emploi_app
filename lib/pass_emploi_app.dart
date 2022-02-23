import 'package:async_redux/async_redux.dart' as async_redux;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart' as flutter_redux;
import 'package:pass_emploi_app/pages/router_page.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/theme.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:redux/redux.dart';

class PassEmploiApp extends StatelessWidget {
  final Store<AppState> storeV1;
  final async_redux.Store<AppState> storeV2;

  PassEmploiApp({required this.storeV1, required this.storeV2});

  @override
  Widget build(BuildContext context) {
    return async_redux.StoreProvider<AppState>(
      store: storeV2,
      child: flutter_redux.StoreProvider<AppState>(
        store: storeV1,
        child: MaterialApp(
          scaffoldMessengerKey: snackbarKey,
          title: Strings.appName,
          theme: PassEmploiTheme.data,
          home: RouterPage(),
        ),
      ),
    );
  }
}
