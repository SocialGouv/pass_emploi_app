import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';

class FilterButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const FilterButton({required this.isEnabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Margins.spacing_base),
      child: PrimaryActionButton(
        onPressed: isEnabled ? onPressed : null,
        label: Strings.applyFiltres,
      ),
    );
  }
}
