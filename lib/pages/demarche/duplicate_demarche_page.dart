import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/matching_demarche/matching_demarche_actions.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_personnalisee_page.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_step3_page.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/presentation/demarche/duplicate_demarche_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

class DuplicateDemarchePage extends StatelessWidget {
  const DuplicateDemarchePage({required this.demarcheId});
  final String demarcheId;

  static MaterialPageRoute<void> route(String demarcheId) {
    return MaterialPageRoute<void>(
      builder: (_) => DuplicateDemarchePage(demarcheId: demarcheId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DuplicateDemarcheViewModel>(
      onInit: (store) => store.dispatch(MatchingDemarcheRequestAction(demarcheId: demarcheId)),
      converter: (store) => DuplicateDemarcheViewModel.create(store, demarcheId),
      builder: (context, viewModel) => _Body(viewModel),
      distinct: true,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.viewModel);
  final DuplicateDemarcheViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.duplicateDemarchePageTitle),
      body: switch (viewModel.displayState) {
        DisplayState.EMPTY => Center(child: CircularProgressIndicator()),
        DisplayState.LOADING => Center(child: CircularProgressIndicator()),
        DisplayState.FAILURE => Retry(Strings.miscellaneousErrorRetry, () => viewModel.onRetry()),
        DisplayState.CONTENT => switch (viewModel.sourceViewModel) {
            DuplicateDemarcheNotInitializedViewModel() => SizedBox.shrink(),
            final DuplicateDemarcheDuReferentielViewModel source =>
              _DuplicateDemarcheDuReferentielState(viewModel, source),
            final DuplicateDemarchePersonnaliseeViewModel source => _DuplicateDemarchePersonnalisee(source),
          },
      },
    );
  }
}

class _DuplicateDemarcheDuReferentielState extends StatelessWidget {
  const _DuplicateDemarcheDuReferentielState(this.viewModel, this.source);
  final DuplicateDemarcheDuReferentielViewModel source;
  final DuplicateDemarcheViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return CreateDemarcheDuReferentielForm(
      idDemarche: source.demarcheDuReferentielId,
      source: MatchingDemarcheSource(),
      initialCodeComment: source.commentCode,
      createDemarcheButtonLabel: Strings.duplicateDemarche,
    );
  }
}

class _DuplicateDemarchePersonnalisee extends StatelessWidget {
  final DuplicateDemarchePersonnaliseeViewModel source;
  const _DuplicateDemarchePersonnalisee(this.source);

  @override
  Widget build(BuildContext context) {
    return DemarchePersonnaliseeForm(
      createDemarcheLabel: Strings.duplicateDemarche,
      initialCommentaire: source.description,
    );
  }
}
