import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_body.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_complement.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_subtitle.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_tag.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_title.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';

class BaseCard extends StatelessWidget {
  final String title;
  final CardTag? tag;
  final CardPillule? pillule;
  final Widget? iconButton;
  final String? subtitle;
  final String? body;
  final List<CardComplement>? complements;
  final List<CardTag>? secondaryTags;
  final List<Widget>? actions;
  final Widget? additionalChild;
  final void Function()? onTap;
  final PressedTip? pressedTip;
  final String? imagePath;

  const BaseCard({
    required this.title,
    this.subtitle,
    this.body,
    this.tag,
    this.pillule,
    this.iconButton,
    this.complements,
    this.secondaryTags,
    this.actions,
    this.additionalChild,
    this.onTap,
    this.pressedTip,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSimpleCard = tag == null && pillule == null;
    return Stack(
      children: [
        CardContainer(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSimpleCard) ...[
                Row(
                  children: [
                    if (tag != null) tag!,
                    Expanded(child: SizedBox()),
                    if (pillule != null) pillule!,
                    if (iconButton != null) iconButton!,
                  ],
                ),
                SizedBox(height: Margins.spacing_base),
              ],
              if (imagePath != null) ...[
                _CardIllustration(imagePath: imagePath!),
                SizedBox(height: Margins.spacing_base),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: CardTitle(title)),
                  if (isSimpleCard && iconButton != null)
                    // This is a hack to make the iconButton appear aligned on the right of the title
                    SizedBox.square(dimension: kMinInteractiveDimension),
                ],
              ),
              SizedBox(height: Margins.spacing_base),
              if (subtitle != null) ...[
                CardSubtitle(subtitle!),
                SizedBox(height: Margins.spacing_base),
              ],
              if (body != null) ...[
                CardBodyText(body!),
                SizedBox(height: Margins.spacing_base),
              ],
              if (complements != null) ...[
                Wrap(spacing: Margins.spacing_base, runSpacing: Margins.spacing_s, children: complements!),
                SizedBox(height: Margins.spacing_base),
              ],
              if (secondaryTags != null) ...[
                Wrap(
                  spacing: Margins.spacing_s,
                  runSpacing: Margins.spacing_s,
                  children: secondaryTags!,
                ),
                SizedBox(height: Margins.spacing_base),
              ],
              if (additionalChild != null) ...[
                additionalChild!,
                SizedBox(height: Margins.spacing_base),
              ],
              if (actions != null) ...[
                SizedBox(height: Margins.spacing_base),
                Wrap(
                  children: actions!,
                ),
              ],
              if (onTap != null) ...[
                SizedBox(height: Margins.spacing_s),
                pressedTip ?? PressedTip(Strings.voirLeDetailCard),
              ],
            ],
          ),
        ),
        if (isSimpleCard && iconButton != null)
          Positioned(
            top: 0,
            right: 0,
            child: iconButton!,
          ),
      ],
    );
  }
}

class _CardIllustration extends StatelessWidget {
  final String? imagePath;

  const _CardIllustration({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radius_base),
        child: Image.asset(
          "assets/${imagePath!}",
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
