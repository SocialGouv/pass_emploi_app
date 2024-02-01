import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_du_referentiel_card_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_tag.dart';

class DemarcheDuReferentielCard extends StatelessWidget {
  final String idDemarche;
  final DemarcheSource source;
  final Function() onTap;

  const DemarcheDuReferentielCard({required this.idDemarche, required this.onTap, required this.source});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DemarcheDuReferentielCardViewModel>(
      builder: _buildBody,
      converter: (store) => DemarcheDuReferentielCardViewModel.create(store, idDemarche, source),
      distinct: true,
    );
  }

  Widget _buildBody(BuildContext context, DemarcheDuReferentielCardViewModel viewModel) {
    return BaseCard(
      tag: CardTag.secondary(text: viewModel.pourquoi),
      title: viewModel.quoi,
      onTap: onTap,
    );
  }
}
