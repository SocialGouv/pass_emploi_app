import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class MandatoryFieldsLabel extends StatelessWidget {
  final bool allFieldsAreMandatory;

  const MandatoryFieldsLabel._({required this.allFieldsAreMandatory});

  factory MandatoryFieldsLabel.all() => MandatoryFieldsLabel._(allFieldsAreMandatory: true);

  factory MandatoryFieldsLabel.some() => MandatoryFieldsLabel._(allFieldsAreMandatory: false);

  @override
  Widget build(BuildContext context) {
    return Text(
      allFieldsAreMandatory ? Strings.allMandatoryFields : Strings.mandatoryFields,
      style: TextStyles.textSRegular(),
    );
  }
}
