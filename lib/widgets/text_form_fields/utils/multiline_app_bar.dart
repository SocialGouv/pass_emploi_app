import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class MultilineAppBar extends StatelessWidget {
  final String title;
  final String? hint;
  final VoidCallback onCloseButtonPressed;

  const MultilineAppBar({required this.title, required this.onCloseButtonPressed, this.hint});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: kToolbarHeight, height: kToolbarHeight),
          child: IconButton(
            onPressed: onCloseButtonPressed,
            tooltip: Strings.close,
            icon: const Icon(Icons.close),
          ),
        ),
        SizedBox(width: Margins.spacing_base),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: Margins.spacing_s, right: Margins.spacing_base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(title, style: TextStyles.textBaseBold),
                ),
                if (hint != null) Text(hint!, style: TextStyles.textSRegularWithColor(AppColors.contentColor)),
              ],
            ),
          ),
        )
      ],
    );
  }
}
