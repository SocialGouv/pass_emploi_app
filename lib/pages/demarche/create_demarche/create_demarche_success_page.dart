import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_form_page.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_detail_page.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_success_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/a11y/auto_focus.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/confetti_wrapper.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/in_app_feedback.dart';

enum CreateDemarcheSource { personnalisee, fromReferentiel, iaFt }

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
        builder: (context, viewModel) => Tracker(
          tracking: switch (source) {
            CreateDemarcheSource.personnalisee => AnalyticsScreenNames.createDemarchePersonnaliseeSuccess,
            CreateDemarcheSource.fromReferentiel => AnalyticsScreenNames.createDemarcheFromReferentielSuccess,
            CreateDemarcheSource.iaFt => AnalyticsScreenNames.createDemarcheIaFtSuccess,
          },
          child: _Content(viewModel, source),
        ),
        converter: (store) => CreateDemarcheSuccessViewModel.create(store, source),
        distinct: true,
        onDispose: (store) => store.dispatch(CreateDemarcheResetAction()),
        onInit: (_) => confettiController.play(),
      );
    });
  }
}

class _Content extends StatelessWidget {
  const _Content(this.viewModel, this.source);
  final CreateDemarcheSuccessViewModel viewModel;
  final CreateDemarcheSource source;

  @override
  Widget build(BuildContext context) {
    return switch (viewModel.displayState) {
      DisplayState.CONTENT => _Body(viewModel, source),
      DisplayState.FAILURE => _Scaffold(body: Center(child: ErrorText(Strings.genericCreationError))),
      _ => _Scaffold(
            body: const Center(
          child: CircularProgressIndicator(),
        )),
    };
  }
}

class _Body extends StatelessWidget {
  const _Body(this.viewModel, this.source);
  final CreateDemarcheSuccessViewModel viewModel;
  final CreateDemarcheSource source;

  @override
  Widget build(BuildContext context) {
    return _Scaffold(
      floatingActionButton: _Buttons(
        onGoActionDetail: viewModel.demarcheId != null
            ? () {
                Navigator.pop(context);
                Navigator.of(context).push(DemarcheDetailPage.materialPageRoute(viewModel.demarcheId!));
              }
            : null,
        onCreateMore: () {
          Navigator.pop(context);
          Navigator.of(context).push(CreateDemarcheFormPage.route());
        },
        source: source,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                    CreateDemarcheSource.iaFt => "create-demarche-ia-ft",
                  },
                  label: Strings.feedbackCreateDemarche,
                ),
                SizedBox(height: Margins.spacing_m),
                Center(
                  child: SizedBox(
                    height: 130,
                    width: 130,
                    child: Image.asset("assets/create_success.webp"),
                  ),
                ),
                SizedBox(height: Margins.spacing_xl),
                Text(
                  switch (source) {
                    CreateDemarcheSource.iaFt => Strings.demarcheSuccessTitlePlural,
                    _ => Strings.demarcheSuccessTitle,
                  },
                  textAlign: TextAlign.center,
                  style: TextStyles.textMBold,
                ),
                SizedBox(height: Margins.spacing_m),
                Text(
                  switch (source) {
                    CreateDemarcheSource.iaFt => Strings.demarcheSuccessSubtitlePlural,
                    _ => Strings.demarcheSuccessSubtitle,
                  },
                  textAlign: TextAlign.center,
                  style: TextStyles.textSRegular(),
                ),
                SizedBox(height: Margins.spacing_xx_huge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons({required this.onGoActionDetail, required this.onCreateMore, required this.source});

  final void Function()? onGoActionDetail;
  final void Function() onCreateMore;
  final CreateDemarcheSource source;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (source == CreateDemarcheSource.iaFt) ...[
            const SizedBox(height: Margins.spacing_base),
            PrimaryActionButton(
              label: Strings.consulterMesDemarches,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ] else ...[
            if (onGoActionDetail != null) ...[
              AutoFocusA11y(
                child: PrimaryActionButton(
                  label: Strings.demarcheSuccessConsulter,
                  onPressed: onGoActionDetail,
                ),
              ),
            ],
            const SizedBox(height: Margins.spacing_base),
            SecondaryButton(
              label: Strings.demarcheSuccessCreerUneAutre,
              onPressed: onCreateMore,
            ),
          ]
        ],
      ),
    );
  }
}

class _Scaffold extends StatelessWidget {
  const _Scaffold({
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    required this.body,
  });
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      appBar: SecondaryAppBar(title: Strings.createDemarcheAppBarTitle, backgroundColor: Colors.white),
      body: body,
    );
  }
}
