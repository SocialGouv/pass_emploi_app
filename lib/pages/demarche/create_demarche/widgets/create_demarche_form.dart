import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche/create_demarche_app_bar_back_button.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche/pages/create_demarche_from_thematique_step_2_page.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche/pages/create_demarche_from_thematique_step_3_page.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche/pages/create_demarche_personnalisee_step_2_page.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche/pages/create_demarche_personnalisee_step_3_page.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche/pages/create_demarche_step_1_page.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_display_state.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_view_model.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_stepper.dart';

class CreateDemarcheForm extends StatefulWidget {
  const CreateDemarcheForm({
    super.key,
    required this.onCreateDemarchePersonnalisee,
    required this.onCreateDemarcheFromReferentiel,
  });

  final void Function(CreateDemarchePersonnaliseeRequestAction) onCreateDemarchePersonnalisee;
  final void Function(CreateDemarcheRequestAction) onCreateDemarcheFromReferentiel;

  @override
  State<CreateDemarcheForm> createState() => _CreateDemarcheFormState();
}

class _CreateDemarcheFormState extends State<CreateDemarcheForm> {
  late final CreateDemarcheFormViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CreateDemarcheFormViewModel();
    _viewModel.addListener(_onFormStateChanged);
  }

  void _onFormStateChanged() {
    if (_viewModel.displayState is CreateDemarcheFromThematiqueSubmitted) {
      widget.onCreateDemarcheFromReferentiel(_viewModel.createDemarcheRequestAction());
    }

    if (_viewModel.displayState is CreateDemarchePersonnaliseeSubmitted) {
      widget.onCreateDemarchePersonnalisee(_viewModel.createDemarchePersonnaliseeRequestAction());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: SecondaryAppBar(
        title: Strings.createDemarcheAppBarTitle,
        leading: AppBarBackButton(_viewModel),
      ),
      body: _Body(_viewModel),
    );
  }
}

class _Body extends StatelessWidget {
  final CreateDemarcheFormViewModel viewModel;

  const _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Margins.spacing_base),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
          child: PassEmploiStepperProgressBar(
            stepCount: CreateDemarcheDisplayState.stepsTotalCount,
            currentStep: viewModel.displayState.index(),
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: AnimationDurations.fast,
            child: Column(
              children: [
                SizedBox(height: Margins.spacing_xs),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
                  child: PassEmploiStepperTexts(
                    stepCount: CreateDemarcheDisplayState.stepsTotalCount,
                    currentStep: viewModel.displayState.index() + 1,
                  ),
                ),
                Expanded(
                  child: switch (viewModel.displayState) {
                    CreateDemarcheStep1() => CreateDemarcheStep1Page(viewModel),
                    CreateDemarcheFromThematiqueStep2() => CreateDemarcheFromThematiqueStep2Page(viewModel),
                    CreateDemarchePersonnaliseeStep2() => CreateDemarchePersonnaliseeStep2Page(viewModel),
                    CreateDemarcheFromThematiqueStep3() ||
                    CreateDemarcheFromThematiqueSubmitted() =>
                      CreateDemarcheFromThematiqueStep3Page(viewModel),
                    CreateDemarchePersonnaliseeStep3() ||
                    CreateDemarchePersonnaliseeSubmitted() =>
                      CreateDemarchePersonnaliseeStep3Page(viewModel),
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
