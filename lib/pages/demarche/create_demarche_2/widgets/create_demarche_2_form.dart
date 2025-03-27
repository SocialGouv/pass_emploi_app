import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_2/create_demarche_app_bar_back_button.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_2/pages/create_demarche_2_confirmation_step_page.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_2/pages/create_demarche_2_from_thematique_step_2_page.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_2/pages/create_demarche_2_from_thematique_step_3_page.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_2/pages/create_demarche_2_personnalisee_step_2_page.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_2/pages/create_demarche_2_personnalisee_step_3_page.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_2/pages/create_demarche_2_step_1_page.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_display_state.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_view_model.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_stepper.dart';

class CreateDemarche2Form extends StatefulWidget {
  const CreateDemarche2Form({super.key});

  @override
  State<CreateDemarche2Form> createState() => _CreateDemarche2FormState();
}

class _CreateDemarche2FormState extends State<CreateDemarche2Form> {
  late final CreateDemarcheFormViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CreateDemarcheFormViewModel();
    _viewModel.addListener(_onFormStateChanged);
  }

  void _onFormStateChanged() {
    // NEXT: Ici logique pour communniquer avec la page du dessus
    // onAbort
    // onSubmit
    // showDialog
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: SecondaryAppBar(
          title: Strings.createDemarcheAppBarTitle,
          leading: AppBarBackButton(_viewModel) // NEXT: Ici logique de retour ou pop,
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
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
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
                    switch (viewModel.displayState) {
                      CreateDemarche2Step1() => CreateDemarche2Step1Page(viewModel),
                      CreateDemarche2ConfirmationStep() => CreateDemarche2ConfirmationStepPage(),
                      CreateDemarche2FromThematiqueStep2() => CreateDemarche2FromThematiqueStep2Page(),
                      CreateDemarche2PersonnaliseeStep2() => CreateDemarche2PersonnaliseeStep2Page(viewModel),
                      CreateDemarche2FromThematiqueStep3() => CreateDemarche2FromThematiqueStep3Page(),
                      CreateDemarche2PersonnaliseeStep3() => CreateDemarche2PersonnaliseeStep3Page(viewModel),
                    },
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
