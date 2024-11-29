import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/evenement_emploi/evenement_emploi_details_page.dart';
import 'package:pass_emploi_app/presentation/evenement_emploi/evenement_emploi_item_view_model.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_complement.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_tag.dart';

class EvenementEmploiCard extends StatelessWidget {
  final EvenementEmploiItemViewModel _viewModel;

  const EvenementEmploiCard(this._viewModel);

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      title: _viewModel.titre,
      tag: CardTag.evenement(text: _viewModel.type),
      complements: [
        CardComplement.date(text: _viewModel.dateLabel),
        CardComplement.hour(text: _viewModel.heureLabel),
        CardComplement.place(text: _viewModel.locationLabel),
      ],
      onTap: () => Navigator.of(context).push(EvenementEmploiDetailsPage.materialPageRoute(_viewModel.id)),
    );
  }
}
