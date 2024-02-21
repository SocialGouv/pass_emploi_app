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
        Text(Strings.startDate, style: TextStyles.textSRegular()),
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
    return Switch.adaptive(
      value: isActiveDate,
      onChanged: (newValue) {
        onIsActiveChange(newValue);
      },
    );
  }
}