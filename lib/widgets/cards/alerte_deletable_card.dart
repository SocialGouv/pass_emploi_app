import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_tag.dart';
import 'package:pass_emploi_app/widgets/tags/data_tag.dart';

class AlerteDeletableCard extends StatelessWidget {
  final OffreType offreType;
  final String title;
  final String? place;
  final VoidCallback onTap;
  final Widget specialAction;

  AlerteDeletableCard({
    required this.title,
    required this.place,
    required this.offreType,
    required this.onTap,
    required VoidCallback onDelete,
  }) : specialAction = IconButton(
          icon: Icon(AppIcons.delete),
          onPressed: onDelete,
          color: AppColors.primary,
        );

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onTap: onTap,
      title: title,
      tag: offreType.toCardTag(),
      iconButton: specialAction,
      secondaryTags: [if (place != null) DataTag.location(place!)],
    );
  }
}
