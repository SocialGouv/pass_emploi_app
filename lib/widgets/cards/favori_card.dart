import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/utils/date_derniere_consultation_provider.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_complement.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_tag.dart';
import 'package:pass_emploi_app/widgets/favori_heart.dart';

class FavoriCard<T> extends StatelessWidget {
  final OffreType offreType;
  final Widget? specialAction;
  final String title;
  final String? company;
  final String? place;
  final String? date;
  final String? offreId;
  final void Function()? onTap;

  FavoriCard({
    super.key,
    this.onTap,
    required this.title,
    this.company,
    required this.place,
    this.date,
    required this.offreType,
    this.specialAction,
    this.offreId,
  });

  FavoriCard.likable({
    super.key,
    this.onTap,
    required this.title,
    this.company,
    required this.place,
    this.date,
    required this.offreType,
    required String id,
    required OffrePage from,
  })  : offreId = id,
        specialAction = FavoriHeart<T>(
          offreId: id,
          a11yLabel: title,
          withBorder: false,
          from: from,
        );

  FavoriCard.deletable({
    super.key,
    this.onTap,
    required this.title,
    this.company,
    required this.place,
    this.date,
    required this.offreType,
    required void Function() onDelete,
  })  : offreId = null,
        specialAction = IconButton(
          icon: Icon(AppIcons.delete),
          onPressed: onDelete,
          color: AppColors.primary,
        );

  @override
  Widget build(BuildContext context) {
    return DateDerniereConsultationProvider(
        id: offreId ?? "",
        builder: (dateDerniereConsultation) {
          return BaseCard(
            onTap: onTap,
            title: title,
            tag: offreType.toCardTag(),
            iconButton: specialAction,
            complements: [
              if (place != null) CardComplement.place(text: place!),
              if (dateDerniereConsultation != null) CardComplement.dateDerniereConsultation(dateDerniereConsultation),
            ],
            secondaryTags: [if (company != null) CardTag.secondary(text: company!)],
          );
        });
  }
}
