import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class RechercheMessagePlaceholder extends StatelessWidget {
  final String message;

  const RechercheMessagePlaceholder(this.message);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return switch (constraints.maxHeight) {
          > 160 => _ImageAndText(message),
          _ => Center(child: _TextOnly(message)),
        };
      },
    );
  }
}

class _ImageAndText extends StatelessWidget {
  final String message;

  const _ImageAndText(this.message);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SvgPicture.asset(Drawables.emptyOffresIllustration),
        _TextOnly(message),
      ],
    );
  }
}

class _TextOnly extends StatelessWidget {
  final String message;

  const _TextOnly(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: Text(message, style: TextStyles.textBaseMedium, textAlign: TextAlign.center),
    );
  }
}
