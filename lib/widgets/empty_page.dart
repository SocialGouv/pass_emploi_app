import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class Empty extends StatelessWidget {
  final String description;

  const Empty({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: Margins.spacing_l),
          Flexible(child: SvgPicture.asset(Drawables.emptyIllustration)),
          Text(description, style: TextStyles.textBaseRegular, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
