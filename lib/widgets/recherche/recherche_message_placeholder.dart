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
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(Drawables.icEmptyOffres),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
            child: Text(message, style: TextStyles.textBaseMedium, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
