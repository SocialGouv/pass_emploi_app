import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class SliderValue extends StatelessWidget {
  final int value;

  const SliderValue({required this.value});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Row(
        children: [
          Flexible(child: Text(Strings.searchRadius, style: TextStyles.textSRegular())),
          Flexible(child: Text(Strings.kmFormat(value), style: TextStyles.textBaseBold)),
        ],
      ),
    );
  }
}
