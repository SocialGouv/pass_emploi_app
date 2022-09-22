import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class VoirSuggestionsRechercheBandeau extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Bandeau(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          _Icon(),
          _Text(),
          _Chevron(),
        ],
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SvgPicture.asset(Drawables.icAlertSuggestions, color: AppColors.accent1, height: 20),
    );
  }
}

class _Text extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(Strings.vosSuggestionsDeRecherche, style: TextStyles.textBaseBold),
    );
  }
}

class _Chevron extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SvgPicture.asset(Drawables.icChevronRight, color: AppColors.contentColor),
    );
  }
}

class _Bandeau extends StatelessWidget {
  final Widget child;

  _Bandeau({required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [Shadows.boxShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => {},
            splashColor: AppColors.primaryLighten,
            child: Padding(
              padding: const EdgeInsets.all(Margins.spacing_base),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
