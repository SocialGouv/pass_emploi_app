import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/demarche_ia_suggestion.dart';
import 'package:pass_emploi_app/presentation/create_demarche_ia_ft_step_3_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';

class CreateDemarcheIaFtStep3Page extends StatelessWidget {
  const CreateDemarcheIaFtStep3Page(this.formViewModel);
  final CreateDemarcheFormViewModel formViewModel;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CreateDemarcheIaFtStep3ViewModel>(
      converter: (store) => CreateDemarcheIaFtStep3ViewModel.create(store),
      builder: (context, viewModel) => _Body(formViewModel: formViewModel, viewModel: viewModel),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.formViewModel, required this.viewModel});
  final CreateDemarcheFormViewModel formViewModel;
  final CreateDemarcheIaFtStep3ViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: switch (viewModel.displayState) {
        DisplayState.CONTENT => _Content(viewModel.suggestions, formViewModel),
        DisplayState.FAILURE => _Failure(formViewModel),
        _ => const _Loading(),
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content(this.suggestions, this.viewModel);
  final List<DemarcheIaSuggestion> suggestions;
  final CreateDemarcheFormViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return _Empty(viewModel);
    }
    return const Placeholder();
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          Drawables.iaFtSuggestionsLoading,
          width: 200,
          height: 200,
        ),
        const SizedBox(height: Margins.spacing_base),
        Text(
          Strings.iaFtSuggestionsLoading,
          style: TextStyles.textMBold,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Margins.spacing_l),
        CircularProgressIndicator(),
      ],
    );
  }
}

class _Failure extends StatelessWidget {
  const _Failure(this.viewModel);
  final CreateDemarcheFormViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          Drawables.iaFtSuggestionsFailure,
          width: 200,
          height: 200,
        ),
        const SizedBox(height: Margins.spacing_m),
        Text(
          Strings.iaFtSuggestionsFailure,
          style: TextStyles.textMBold,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Margins.spacing_m),
        PrimaryActionButton(
          onPressed: () => viewModel.navigateToCreateDemarcheIaFtStep2(),
          label: Strings.back,
        ),
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty(this.viewModel);
  final CreateDemarcheFormViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          Drawables.iaFtSuggestionsEmpty,
          width: 200,
          height: 200,
        ),
        const SizedBox(height: Margins.spacing_m),
        Text(
          Strings.iaFtSuggestionsEmpty,
          style: TextStyles.textMBold,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Margins.spacing_m),
        PrimaryActionButton(
          onPressed: () => viewModel.navigateToCreateDemarcheIaFtStep2(),
          label: Strings.back,
        ),
      ],
    );
  }
}
