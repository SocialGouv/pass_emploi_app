// ignore_for_file: use_decorated_box

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/presentation/choix_mode_demo_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';

class ChoixModeDemoPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(
      builder: (context) => ChoixModeDemoPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.explicationModeDemo,
      child: StoreConnector<AppState, ChoixModeDemoViewModel>(
          converter: (store) => ChoixModeDemoViewModel.create(store),
          builder: (context, viewModel) {
            return Scaffold(
              body: Stack(
                children: [
                  _Background(),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _BackButton(),
                      Expanded(
                        child: _Contenu(viewModel),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class _Contenu extends StatelessWidget {
  final ChoixModeDemoViewModel viewModel;

  const _Contenu(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimens.radius_base),
          boxShadow: [Shadows.radius_base],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Semantics(
                  header: true,
                  child: Text(
                    Strings.modeDemoExplicationTitre,
                    style: TextStyles.secondaryAppBar,
                  ),
                ),
              )),
              SizedBox(height: Margins.spacing_m),
              Center(
                child: SizedBox(
                  height: 130,
                  width: 130,
                  child: Illustration.blue(AppIcons.lock_rounded),
                ),
              ),
              SizedBox(height: Margins.spacing_m),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 40, right: 24),
                child: Text(
                  Strings.modeDemoExplicationChoix,
                  textAlign: TextAlign.center,
                  style: TextStyles.textBaseBold,
                ),
              ),
              _BoutonPE(),
              if (viewModel.shouldDisplayMiloMode) _BoutonMILO(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.primary, borderRadius: BorderRadius.vertical(bottom: Radius.circular(123456789))),
          ),
        ),
        Expanded(flex: 1, child: Container()),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 40),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: Icon(
            AppIcons.chevron_left_rounded,
            color: Colors.white,
            size: Dimens.icon_size_m,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

class _BoutonPE extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: PrimaryActionButton(
        label: Strings.loginPoleEmploi,
        backgroundColor: AppColors.poleEmploi,
        onPressed: () {
          StoreProvider.of<AppState>(context).dispatch(RequestLoginAction(LoginMode.DEMO_PE));
        },
      ),
    );
  }
}

class _BoutonMILO extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
      child: PrimaryActionButton(
        label: Strings.loginMissionLocale,
        backgroundColor: AppColors.missionLocale,
        onPressed: () {
          StoreProvider.of<AppState>(context).dispatch(RequestLoginAction(LoginMode.DEMO_MILO));
        },
      ),
    );
  }
}
