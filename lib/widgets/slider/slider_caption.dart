import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class SliderCaption extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(Strings.kmFormat(0), style: TextStyles.textSBold),
        Text(Strings.kmFormat(100), style: TextStyles.textSBold),
      ],
    );
  }
}
