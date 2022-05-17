import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';

class FilterButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const FilterButton({required this.isEnabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      onPressed: isEnabled ? onPressed : null,
      label: Strings.applyFiltres,
    );
  }
}