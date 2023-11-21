import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_card_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_complement.dart';

class DemarcheCard extends StatelessWidget {
  final String demarcheId;
  final DemarcheStateSource stateSource;
  final Function() onTap;

  const DemarcheCard({
    required this.demarcheId,
    required this.stateSource,
    required this.onTap,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DemarcheCardViewModel>(
      rebuildOnChange: false,
      converter: (store) => DemarcheCardViewModel.create(
        store: store,
        stateSource: stateSource,
        demarcheId: demarcheId,
      ),
      builder: _build,
    );
  }

  Widget _build(BuildContext context, DemarcheCardViewModel viewModel) {
    return BaseCard(
      pillule: viewModel.pilluleType?.toCardPillule(),
      title: viewModel.titre,
      subtitle: viewModel.sousTitre,
      onTap: onTap,
      complements: [
        viewModel.isLate
            ? CardComplement.dateLate(text: viewModel.dateTexts)
            : CardComplement.date(text: viewModel.dateTexts),
      ],
    );
  }
}
