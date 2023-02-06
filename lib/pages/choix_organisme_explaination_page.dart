import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/choix_organisme_explaination_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/primary_rounded_bottom_background.dart';

class ChoixOrganismeExplainationPage extends StatelessWidget {
  final bool isPoleEmploi;

  const ChoixOrganismeExplainationPage(this.isPoleEmploi);

  static MaterialPageRoute<void> materialPageRoute({required bool isPoleEmploi}) {
    return MaterialPageRoute(builder: (context) => ChoixOrganismeExplainationPage(isPoleEmploi));
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: isPoleEmploi ? AnalyticsScreenNames.choixOrganismePE : AnalyticsScreenNames.choixOrganismeMilo,
      child: StoreConnector<AppState, ChoixOrganismeExplainationViewModel>(
        converter: (store) => ChoixOrganismeExplainationViewModel.create(store, isPoleEmploi: isPoleEmploi),
        builder: (context, vm) => Scaffold(
          body: Stack(
            children: [
              PrimaryRoundedBottomBackground(),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _backButton(context),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(Margins.spacing_m, Margins.spacing_m, Margins.spacing_m, 0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.white, borderRadius: BorderRadius.circular(Dimens.radius_base)),
                                child: Padding(
                                  padding: const EdgeInsets.all(Margins.spacing_m),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      SvgPicture.asset(Drawables.conversation),
                                      Text(
                                        vm.explainationText,
                                        style: TextStyles.textMRegular,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: Margins.spacing_base),
                            Text(
                              Strings.alreadyHaveAccount,
                              style: TextStyles.textBaseRegular,
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(Margins.spacing_m),
                              child: SecondaryButton(label: Strings.loginAction, onPressed: vm.loginAction),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        Drawables.icChevronLeft,
        color: Colors.white,
        height: Margins.spacing_xl,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
