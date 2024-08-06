import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class MandatoryFieldsLabel extends StatelessWidget {
  MandatoryFieldsLabel.all() : label = Strings.allMandatoryFields;

  MandatoryFieldsLabel.some() : label = Strings.mandatoryFields;

  MandatoryFieldsLabel.single() : label = Strings.mandatoryField;

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyles.textSRegular(),
    );
  }
}
