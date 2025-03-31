import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_2_form_page.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_detail_page.dart';
import 'package:pass_emploi_app/pages/mon_suivi_page.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_success_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/a11y/auto_focus.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/confetti_wrapper.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
import 'package:pass_emploi_app/widgets/in_app_feedback.dart';

enum CreateDemarcheSource { personnalisee, fromReferentiel }

class CreateDemarcheSuccessPage extends StatelessWidget {
  const CreateDemarcheSuccessPage({super.key, required this.source});
  final CreateDemarcheSource source;

  static Route<dynamic> route(CreateDemarcheSource source) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => CreateDemarcheSuccessPage(source: source),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiWrapper(builder: (context, confettiController) {
      return StoreConnector<AppState, CreateDemarcheSuccessViewModel>(
        builder: (context, viewModel) => _Body(viewModel, source),
        converter: (store) => CreateDemarcheSuccessViewModel.create(store),
        distinct: true,
        onDispose: (store) => store.dispatch(CreateDemarcheResetAction()),
        onInit: (_) => confettiController.play(),
      );
    });
  }
}

class _Body extends StatelessWidget {
  const _Body(this.viewModel, this.source);
  final CreateDemarcheSuccessViewModel viewModel;
  final CreateDemarcheSource source;

  @override
  Widget build(BuildContext context) {
    return CreateDemarcheABWrapper(
      eventNameWith: AnalyticsEventNames.aBtestCreationDemarcheSuccessAfficheWith,
      eventNameWithout: AnalyticsEventNames.aBtestCreationDemarcheSuccessAfficheWithout,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: _Buttons(
          onGoActionDetail: () {
            Navigator.pop(context);
            Navigator.of(context).push(DemarcheDetailPage.materialPageRoute(viewModel.demarcheId));
          },
          onCreateMore: () {
            Navigator.pop(context);
            Navigator.of(context).push(CreateDemarche2FormPage.route());
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: SecondaryAppBar(title: Strings.createDemarcheAppBarTitle, backgroundColor: Colors.white),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InAppFeedback(
                    feature: switch (source) {
                      CreateDemarcheSource.personnalisee => "create-demarche-personnalisee",
                      CreateDemarcheSource.fromReferentiel => "create-demarche-referentiel",
                    },
                    label: Strings.feedbackCreateDemarche,
                  ),
                  SizedBox(height: Margins.spacing_m),
                  Center(
                    child: SizedBox(
                      height: 130,
                      width: 130,
                      child: Illustration.green(AppIcons.check_rounded),
                    ),
                  ),
                  SizedBox(height: Margins.spacing_xl),
                  Text(
                    Strings.demarcheSuccessTitle,
                    textAlign: TextAlign.center,
                    style: TextStyles.textMBold,
                  ),
                  SizedBox(height: Margins.spacing_m),
                  Text(
                    Strings.demarcheSuccessSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyles.textSRegular(),
                  ),
                  SizedBox(height: Margins.spacing_xx_huge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons({required this.onGoActionDetail, required this.onCreateMore});

  final void Function() onGoActionDetail;
  final void Function() onCreateMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AutoFocusA11y(
            child: PrimaryActionButton(
              label: Strings.demarcheSuccessConsulter,
              onPressed: onGoActionDetail,
            ),
          ),
          const SizedBox(height: Margins.spacing_base),
          SecondaryButton(
            label: Strings.demarcheSuccessCreerUneAutre,
            onPressed: onCreateMore,
          ),
        ],
      ),
    );
  }
}
