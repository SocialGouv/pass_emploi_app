import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/focused_border_builder.dart';

class CriteresRechercheExpansionTile extends StatelessWidget {
  final int criteresActifsCount;
  final bool initiallyExpanded;
  final Widget child;
  final Function(bool isOpen) onExpansionChanged;

  CriteresRechercheExpansionTile({
    required this.initiallyExpanded,
    required this.criteresActifsCount,
    required this.child,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    const mainAnimationCurve = Curves.ease;
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: initiallyExpanded ? Colors.white : AppColors.primary,
        borderRadius: BorderRadius.circular(Dimens.radius_base),
        boxShadow: [Shadows.radius_base],
      ),
      duration: AnimationDurations.medium,
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
            duration: AnimationDurations.medium,
            sizeCurve: mainAnimationCurve,
          ),
        ],
      ),
    );
  }
}

class _CriteresRechercheBandeau extends StatefulWidget {
  final int criteresActifsCount;
  final bool isOpen;
  final void Function() onTap;

  const _CriteresRechercheBandeau({
    required this.criteresActifsCount,
    required this.isOpen,
    required this.onTap,
  });

  @override
  State<_CriteresRechercheBandeau> createState() => _CriteresRechercheBandeauState();
}

class _CriteresRechercheBandeauState extends State<_CriteresRechercheBandeau> {
  bool initialBuild = true;

  @override
  void didUpdateWidget(covariant _CriteresRechercheBandeau oldWidget) {
    initialBuild = false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FocusedBorderBuilder(
      borderColor: AppColors.primaryDarkenStrong,
      borderRadius: Dimens.radius_base,
      builder: (focusNode) {
        return Semantics(
          // On initial build, role header is given, as widget not clickable.
          // Later, role button is given
          header: initialBuild ? true : null,
          button: initialBuild ? null : true,
          label: Strings.rechercheCriteresActifsTooltip(widget.isOpen),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimens.radius_base),
            child: InkWell(
              onTap: widget.onTap,
              focusNode: focusNode,
              child: Padding(
                padding: EdgeInsets.all(Margins.spacing_base),
                child: Row(
                  children: [
                    Icon(Icons.search, color: widget.isOpen ? AppColors.primary : Colors.white),
                    SizedBox(width: Margins.spacing_base),
                    Expanded(
                      child: Text(
                        Intl.plural(
                          widget.criteresActifsCount,
                          zero: Strings.rechercheCriteresActifsZero,
                          one: Strings.rechercheCriteresActifsOne,
                          other: Strings.rechercheCriteresActifsPlural(widget.criteresActifsCount),
                        ),
                        style: TextStyles.textBaseMediumBold(
                          color: widget.isOpen ? AppColors.contentColor : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
