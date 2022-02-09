import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/secondary_button.dart';

class ProfilPage extends TraceableStatelessWidget {
  ProfilPage() : super(name: AnalyticsScreenNames.plus);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: passEmploiAppBar(label: Strings.menuProfil),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacing_m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SecondaryButton(
                onPressed: () {
                  StoreProvider.of<AppState>(context).dispatch(RequestLogoutAction(LogoutRequester.USER));
                },
                label: Strings.logoutAction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
