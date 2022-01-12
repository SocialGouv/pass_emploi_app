import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/primary_action_button.dart';

class PlusPage extends TraceableStatelessWidget {
  PlusPage() : super(name: AnalyticsScreenNames.plus);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: FlatDefaultAppBar(title: Text(Strings.menuPlus, style: TextStyles.h3Semi)),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryActionButton.simple(
                      onPressed: () {
                        StoreProvider.of<AppState>(context).dispatch(RequestLogoutAction(LogoutRequester.USER));
                      },
                      label: Strings.logoutAction,
                      textColor: AppColors.warning,
                      backgroundColor: AppColors.warningLighten,
                      rippleColor: AppColors.redGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
