import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/presentation/offre_emploi/offre_emploi_origin_view_model.dart';
import 'package:pass_emploi_app/utils/date_derniere_consultation_provider.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_complement.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_tag.dart';
import 'package:pass_emploi_app/widgets/favori_heart.dart';
import 'package:pass_emploi_app/widgets/offre_emploi_origin.dart';
import 'package:pass_emploi_app/widgets/tags/data_tag.dart';

class FavoriLikeableCard<T> extends StatelessWidget {
  final String id;
  final OffreType offreType;
  final String title;
  final String? company;
  final String? place;
  final Origin? origin;
  final VoidCallback onTap;
  final Widget specialAction;

  FavoriLikeableCard({
    required OffrePage from,
    required this.id,
    required this.offreType,
    required this.title,
    required this.company,
    required this.place,
    required this.origin,
    required this.onTap,
  }) : specialAction = FavoriHeart<T>(
          offreId: id,
          a11yLabel: title,
          withBorder: false,
          from: from,
        );

  @override
  Widget build(BuildContext context) {
    return DateDerniereActionProvider(
      id: id,
      builder: (dateActionViewModel) {
        return BaseCard(
          onTap: onTap,
          title: title,
          subtitle: company,
          tag: OffreEmploiOriginViewModel.from(origin)?.toWidget(OffreEmploiOriginSize.small),
          iconButton: specialAction,
          secondaryTags: [
            offreType.toCardTag(),
            if (place != null) DataTag.location(place!),
          ],
          complements: [
            if (dateActionViewModel.datePostulation != null)
              CardComplement.datePostulation(dateActionViewModel.datePostulation!)
            else if (dateActionViewModel.dateDerniereConsultation != null)
              CardComplement.dateDerniereConsultation(dateActionViewModel.dateDerniereConsultation!)
          ],
        );
      },
    );
  }
}
