import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/mode_demo/page_choix_mode_demo.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';

class ExplicationModeDemoPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(
      builder: (context) => ExplicationModeDemoPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.explicationModeDemo,
      child: Scaffold(
        body: Stack(
          children: [
            _Background(),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _BackButton(),
                Expanded(
                  child: _Contenu(),
                ),
                _BoutonContinuer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Contenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
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
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: RichText(
                  textScaler: MediaQuery.of(context).textScaler,
                  text: TextSpan(
                    children: [
                      TextSpan(text: Strings.modeDemoExplicationPremierPoint1, style: TextStyles.textBaseRegular),
                      TextSpan(text: Strings.modeDemoExplicationPremierPoint2, style: TextStyles.textBaseBold),
                      TextSpan(text: Strings.modeDemoExplicationPremierPoint3, style: TextStyles.textBaseRegular),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: Strings.modeDemoExplicationSecondPoint1, style: TextStyles.textBaseRegular),
                      TextSpan(text: Strings.modeDemoExplicationSecondPoint2, style: TextStyles.textBaseBold),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, bottom: 30, right: 24),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: Strings.modeDemoExplicationTroisiemePoint1, style: TextStyles.textBaseRegular),
                      TextSpan(text: Strings.modeDemoExplicationTroisiemePoint2, style: TextStyles.textBaseBold),
                    ],
                  ),
                ),
              ),
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
              decoration:
                  BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(double.infinity))),
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

class _BoutonContinuer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
      child: PrimaryActionButton(
        label: Strings.continueLabel,
        onPressed: () {
          Navigator.push(context, ChoixModeDemoPage.materialPageRoute());
        },
      ),
    );
  }
}
