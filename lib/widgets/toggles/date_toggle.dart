import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class DateToggle extends StatelessWidget {
  final Function(bool) onIsActiveChange;
  final bool isActiveDate;

  DateToggle({required this.onIsActiveChange, required this.isActiveDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ExcludeSemantics(child: Text(Strings.startDate, style: TextStyles.textSRegular())),
        _StartDateToggle(
          onIsActiveChange: onIsActiveChange,
          isActiveDate: isActiveDate,
        ),
      ],
    );
  }
}

class _StartDateToggle extends StatelessWidget {
  final Function(bool) onIsActiveChange;
  final bool isActiveDate;

  _StartDateToggle({
    required this.onIsActiveChange,
    required this.isActiveDate,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: Strings.startDateEnabled(isActiveDate),
      child: Switch.adaptive(
        value: isActiveDate,
        onChanged: onIsActiveChange,
      ),
    );
  }
}