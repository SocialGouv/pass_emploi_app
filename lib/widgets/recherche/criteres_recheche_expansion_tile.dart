import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CriteresRechercheExpansionTile extends StatelessWidget {
  final int criteresActifsCount;
  final bool initiallyExpanded;
  final Widget child;
  final Function(bool isOpen) onExpansionChanged;

  const CriteresRechercheExpansionTile({
    required this.initiallyExpanded,
    required this.criteresActifsCount,
    required this.child,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final mainAnimationDuration = Duration(milliseconds: 300);
    const mainAnimationCurve = Curves.ease;
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: initiallyExpanded ? Colors.white : AppColors.primary,
        borderRadius: BorderRadius.circular(Dimens.radius_base),
        boxShadow: [Shadows.radius_base],
      ),
      duration: mainAnimationDuration,
      curve: mainAnimationCurve,
      child: Column(
        children: [
          _CriteresRechercheBandeau(
            isOpen: initiallyExpanded,
            criteresActifsCount: criteresActifsCount,
            onTap: () => onExpansionChanged(!initiallyExpanded),
          ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: child,
            crossFadeState: initiallyExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: mainAnimationDuration,
            sizeCurve: mainAnimationCurve,
          ),
        ],
      ),
    );
  }
}

class _CriteresRechercheBandeau extends StatelessWidget {
  final int criteresActifsCount;
  final bool isOpen;
  final void Function() onTap;

  const _CriteresRechercheBandeau({
    required this.criteresActifsCount,
    required this.isOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isOpen ? AppColors.primary : Colors.white;
    return Semantics(
      button: true,
      enabled: true,
      label: Strings.rechercheCriteresActifsTooltip(isOpen),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radius_base),
        child: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(Margins.spacing_base),
            child: Row(
              children: [
                Icon(Icons.search, color: iconColor),
                SizedBox(width: Margins.spacing_base),
                Expanded(
                  child: Text(
                    Intl.plural(
                      criteresActifsCount,
                      zero: Strings.rechercheCriteresActifsSingular(criteresActifsCount),
                      one: Strings.rechercheCriteresActifsSingular(criteresActifsCount),
                      other: Strings.rechercheCriteresActifsPlural(criteresActifsCount),
                    ),
                    style: TextStyles.textBaseMediumBold(color: isOpen ? AppColors.contentColor : Colors.white),
                  ),
                ),
                AnimatedRotation(
                  turns: !isOpen ? -0.5 : 0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                  child: Icon(Icons.expand_less_rounded, color: iconColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
