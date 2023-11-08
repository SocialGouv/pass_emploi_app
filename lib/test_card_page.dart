import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';

class TestCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Test Appbar'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BaseCardS(),
          ],
        ),
      ),
    );
  }
}

class _BaseCardS extends StatelessWidget {
  const _BaseCardS();

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Tag(
                icon: Icons.business_center_outlined,
                backgroundColor: AppColors.accent2Lighten,
                text: "Offre d'emploi",
                contentColor: AppColors.accent3,
              ),
              Expanded(child: SizedBox()),
              _Pillule(),
              _IconButton()
            ],
          ),
          SizedBox(height: Margins.spacing_m),
          _CardTitle(),
          SizedBox(height: Margins.spacing_base),
          _CardSubtitle(),
          SizedBox(height: Margins.spacing_base),
          Tag(
            icon: Icons.volunteer_activism,
            backgroundColor: AppColors.additional1Lighten,
            text: "Entreprise accueillante",
            contentColor: AppColors.accent2,
          ),
          SizedBox(height: Margins.spacing_base),
          _BodyText(),
          SizedBox(height: Margins.spacing_base),
          Wrap(
            spacing: Margins.spacing_base,
            runSpacing: Margins.spacing_s,
            children: [
              _Complement(text: "Complément 1"),
              _Complement(text: "Complément 2"),
              _Complement(text: "Complément 3"),
              _Complement(text: "Complément 4"),
            ],
          ),
          SizedBox(height: Margins.spacing_base),
          Wrap(
            spacing: Margins.spacing_s,
            runSpacing: Margins.spacing_s,
            children: [
              Tag.secondary(text: "Tag info 1"),
              Tag.secondary(text: "Tag info 2"),
              Tag.secondary(text: "Tag info 3"),
            ],
          ),
          SizedBox(height: Margins.spacing_m),
          _Actions(),
          SizedBox(height: Margins.spacing_m),
          PressedTip("Voir le détail"),
        ],
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Titre de la carte sur trois lignes ou plus avec troncature auto à trois lignes",
      style: TextStyles.textBaseBold.copyWith(
        fontSize: 16,
        color: AppColors.contentColor,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class Tag extends StatelessWidget {
  const Tag({
    this.icon,
    required this.backgroundColor,
    required this.text,
    required this.contentColor,
  });

  Tag.secondary({
    this.icon,
    required this.text,
  })  : backgroundColor = AppColors.primaryLighten,
        contentColor = AppColors.primary;

  final IconData? icon;
  final Color backgroundColor;
  final String text;
  final Color contentColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radius_base),
        color: backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Margins.spacing_s,
          vertical: Margins.spacing_xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: contentColor),
              SizedBox(width: Margins.spacing_xs),
            ],
            Text(
              text,
              style: TextStyles.textXsBold().copyWith(color: contentColor),
            )
          ],
        ),
      ),
    );
  }
}

class _Pillule extends StatelessWidget {
  const _Pillule();

  @override
  Widget build(BuildContext context) {
    const contentColor = AppColors.accent2;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radius_l),
        color: AppColors.accent3Lighten,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Margins.spacing_s,
          vertical: Margins.spacing_xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt, size: 16, color: contentColor),
            SizedBox(width: Margins.spacing_xs),
            Text(
              "À réaliser",
              style: TextStyles.textXsBold().copyWith(color: contentColor),
            )
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(AppIcons.delete, color: AppColors.primary),
      onPressed: () {},
    );
  }
}

class _CardSubtitle extends StatelessWidget {
  const _CardSubtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Sous-titre card",
      style: TextStyles.textXsBold(color: AppColors.grey800),
    );
  }
}

class _BodyText extends StatelessWidget {
  const _BodyText();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Description texte_s pour apporter du complément, avec troncature automatique au bout de trois lignes si ça veut bien. Lorem ipsus im dorlor",
      style: TextStyles.textSRegular(color: AppColors.contentColor).copyWith(height: 1.7),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _Complement extends StatelessWidget {
  const _Complement({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    const contentColor = AppColors.grey800;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.settings,
          size: 16,
          color: contentColor,
        ),
        SizedBox(width: Margins.spacing_xs),
        Text(
          text,
          style: TextStyles.textSRegular().copyWith(color: contentColor),
        )
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: SecondaryButton(
            label: "label",
            icon: AppIcons.delete,
            onPressed: () {},
          ),
        ),
        SizedBox(width: Margins.spacing_base),
        Expanded(
          child: PrimaryActionButton(
            label: "label",
            icon: AppIcons.add_rounded,
            onPressed: () {},
          ),
        )
      ],
    );
  }
}
