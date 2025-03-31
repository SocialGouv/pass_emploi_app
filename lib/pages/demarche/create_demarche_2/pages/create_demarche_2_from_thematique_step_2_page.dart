import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_actions.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_du_referentiel_card_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';

class CreateDemarche2FromThematiqueStep2Page extends StatelessWidget {
  const CreateDemarche2FromThematiqueStep2Page(this.viewModel);
  final CreateDemarcheFormViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final selectedThematique = viewModel.step1ViewModel.selectedThematique;

    if (selectedThematique == null) {
      return const SizedBox();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: Margins.spacing_base),
          Text(selectedThematique.title, style: TextStyles.textMBold),
          const SizedBox(height: Margins.spacing_base),
          Text(Strings.selectDemarche, style: TextStyles.textBaseMedium),
          const SizedBox(height: Margins.spacing_base),
          _ThematiqueDemarcheList(
            thematiqueCode: selectedThematique.id,
            viewModel: viewModel,
          ),
          SizedBox(height: Margins.spacing_xl),
        ],
      ),
    );
  }
}

class _ThematiqueDemarcheList extends StatelessWidget {
  const _ThematiqueDemarcheList({required this.thematiqueCode, required this.viewModel});
  final String thematiqueCode;
  final CreateDemarcheFormViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final thematiqueSource = ThematiqueDemarcheSource(thematiqueCode);
    return StoreConnector<AppState, List<String>>(
      onInit: (store) => store.dispatch(ThematiqueDemarcheRequestAction()),
      converter: (store) => thematiqueSource.demarcheList(store).map((demarche) => demarche.id).toList(),
      builder: (context, demarchesIds) => ListView.separated(
        itemCount: demarchesIds.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_s),
        itemBuilder: (context, index) {
          final id = demarchesIds[index];
          return _DemarcheDuReferentielCard(
            source: thematiqueSource,
            idDemarche: id,
            onSelected: (demarcheCardViewModel) => viewModel.demarcheSelected(demarcheCardViewModel),
          );
        },
      ),
      distinct: true,
    );
  }
}

class _DemarcheDuReferentielCard extends StatelessWidget {
  final String idDemarche;
  final DemarcheSource source;
  final Function(DemarcheDuReferentielCardViewModel) onSelected;

  const _DemarcheDuReferentielCard({required this.idDemarche, required this.onSelected, required this.source});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DemarcheDuReferentielCardViewModel>(
      builder: _buildBody,
      converter: (store) => DemarcheDuReferentielCardViewModel.create(store, idDemarche, source),
      distinct: true,
    );
  }

  Widget _buildBody(BuildContext context, DemarcheDuReferentielCardViewModel viewModel) {
    return CardContainer(
      onTap: () => onSelected(viewModel),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 40),
        child: Center(
          child: Text(
            viewModel.quoi,
            textAlign: TextAlign.center,
            style: TextStyles.textSMedium(),
          ),
        ),
      ),
    );
  }
}
