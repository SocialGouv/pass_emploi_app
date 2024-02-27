import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class ElevatedButtonTile extends StatelessWidget {
  const ElevatedButtonTile({super.key, required this.onPressed, required this.label, this.leading, this.suffix});
  final VoidCallback onPressed;
  final String label;
  final Widget? leading;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radius_base),
        color: Colors.white,
        boxShadow: [Shadows.radius_base],
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(Dimens.radius_base),
          onTap: onPressed,
          child: Semantics(
            button: true,
            child: Padding(
              padding: EdgeInsets.all(Margins.spacing_m),
              child: Row(
                children: [
                  if (leading != null) leading!,
                  if (leading != null) SizedBox(width: Margins.spacing_base),
                  Expanded(child: Text(label, style: TextStyles.textBaseBold)),
                  if (suffix != null) suffix!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
