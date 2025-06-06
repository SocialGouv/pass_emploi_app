import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_body.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_complement.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_subtitle.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_title.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';

class BaseCard extends StatelessWidget {
  final String title;
  final Widget? tag;
  final CardPillule? pillule;
  final Widget? iconButton;
  final String? subtitle;
  final String? body;
  final List<Widget>? secondaryTags;
  final List<CardComplement>? complements;
  final List<Widget>? actions;
  final Widget? additionalChild;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final PressedTip? pressedTip;
  final String? imagePath;
  final String? imageAlt;
  final bool linkRole;

  const BaseCard({
    required this.title,
    this.subtitle,
    this.body,
    this.tag,
    this.pillule,
    this.iconButton,
    this.secondaryTags,
    this.complements,
    this.actions,
    this.additionalChild,
    this.onTap,
    this.onLongPress,
    this.pressedTip,
    this.imagePath,
    this.imageAlt,
    this.linkRole = false,
  });

  @override
  Widget build(BuildContext context) {
    assert(pillule == null || iconButton == null, "A BaseCard can't have both a pillule and an iconButton.");
    final bool isSimpleCard = tag == null && pillule == null;
    return Semantics(
      button: !linkRole && onTap != null ? true : null,
      link: linkRole ? true : null,
      child: Stack(
        children: [
          CardContainer(
            padding: EdgeInsets.all(Margins.spacing_base),
            onTap: onTap,
            onLongPress: onLongPress,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imagePath != null) ...[
                    Semantics(
                      excludeSemantics: imageAlt != null,
                      image: true,
                      label: imageAlt,
                      child: _CardIllustration(imagePath: imagePath!),
                    ),
                    SizedBox(height: Margins.spacing_base),
                  ],
                  if (!isSimpleCard && iconButton == null)
                    Wrap(
                      spacing: Margins.spacing_s,
                      runSpacing: Margins.spacing_s,
                      children: [
                        if (tag != null) tag!,
                        if (pillule != null) pillule!,
                      ],
                    ),
                  if (!isSimpleCard && iconButton != null) ...[
                    if (tag != null) tag!,
                    SizedBox(height: Margins.spacing_s),
                  ],
                  if (title.isNotEmpty) ...[
                    if ((!isSimpleCard && iconButton == null) || imagePath != null) SizedBox(height: Margins.spacing_s),
                    CardTitle(title),
                  ],
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    SizedBox(height: Margins.spacing_base),
                    CardSubtitle(subtitle!),
                  ],
                  if (body != null && body!.isNotEmpty) ...[
                    SizedBox(height: Margins.spacing_base),
                    CardBodyText(body!),
                  ],
                  if (secondaryTags != null && secondaryTags!.isNotEmpty) ...[
                    SizedBox(height: Margins.spacing_base),
                    Wrap(
                      spacing: Margins.spacing_s,
                      runSpacing: Margins.spacing_s,
                      children: secondaryTags!,
                    ),
                  ],
                  if (complements != null && complements!.isNotEmpty) ...[
                    SizedBox(height: Margins.spacing_base),
                    Wrap(spacing: Margins.spacing_base, runSpacing: Margins.spacing_s, children: complements!),
                  ],
                  if (additionalChild != null) ...[
                    SizedBox(height: Margins.spacing_base),
                    additionalChild!,
                  ],
                  if (actions != null && actions!.isNotEmpty) ...[
                    SizedBox(height: Margins.spacing_base),
                    Wrap(
                      children: actions!,
                    ),
                  ],
                  if (onTap != null && pressedTip != null) ...[
                    SizedBox(height: Margins.spacing_s),
                    pressedTip!,
                  ],
                ],
              ),
            ),
          ),
          if (iconButton != null)
            Positioned(
              top: 0,
              right: 0,
              child: iconButton!,
            ),
        ],
      ),
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
