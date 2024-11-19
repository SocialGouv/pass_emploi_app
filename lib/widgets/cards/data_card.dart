import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/utils/date_derniere_consultation_provider.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_complement.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_tag.dart';
import 'package:pass_emploi_app/widgets/favori_heart.dart';

class DataCard<T> extends StatelessWidget {
  final String titre;
  final String? category;
  final String? sousTitre;
  final String? lieu;
  final String? date;
  final List<String> dataTag;
  final VoidCallback onTap;
  final String? id;
  final OffrePage? from;
  final Widget? tag;
  final Widget? additionalChild;
  final bool withFavori;

  const DataCard({
    super.key,
    required this.titre,
    required this.sousTitre,
    required this.lieu,
    required this.dataTag,
    required this.onTap,
    this.date,
    this.id,
    this.from,
    this.category,
    this.tag,
    this.additionalChild,
    this.withFavori = true,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> nonEmptyDataTags = dataTag.where((element) => element.isNotEmpty).toList();
    return DateDerniereConsultationProvider(
        id: id ?? "",
        builder: (dateDerniereConsultation) {
          return BaseCard(
            onTap: onTap,
            title: titre,
            subtitle: sousTitre,
            tag: tag,
            complements: [
              if (lieu != null && lieu!.isNotEmpty) CardComplement.place(text: lieu!),
              if (date != null && date!.isNotEmpty) CardComplement.date(text: date!),
              if (dateDerniereConsultation != null) CardComplement.dateDerniereConsultation(dateDerniereConsultation),
            ],
            secondaryTags: [
              if (category != null && category!.isNotEmpty) CardTag.secondary(text: category!),
              ...nonEmptyDataTags.map((e) => CardTag.secondary(text: e)),
            ],
            iconButton: (withFavori && id != null && from != null)
                ? FavoriHeart<T>(
                    offreId: id!,
                    a11yLabel: sousTitre != null ? '$titre ${sousTitre!}' : titre,
                    withBorder: false,
                    from: from!,
                  )
                : null,
            additionalChild: additionalChild,
          );
        });
  }
}
