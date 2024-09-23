import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/media_sizes.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class Welcome extends StatelessWidget {
  final bool small;

  const Welcome({super.key, this.small = false});
  const Welcome.small({super.key}) : small = true;

  @override
  Widget build(BuildContext context) {
    final shrink = MediaQuery.of(context).size.width < MediaSizes.width_s;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25 * (shrink ? 1 : 2)),
      child: Column(
        children: [
          Text(
            Strings.welcome,
            style: TextStyles.textLBold(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          if (!small) ...[
            SizedBox(height: Margins.spacing_base),
            Text(
              Strings.welcomeMessage,
              style: TextStyles.textBaseRegular.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Margins.spacing_m),
          ]
        ],
      ),
    );
  }
}
