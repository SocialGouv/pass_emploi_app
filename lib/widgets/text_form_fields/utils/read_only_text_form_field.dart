import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/text_form_field_input_decoration.dart';

class ReadOnlyTextFormField extends StatelessWidget {
  final String title;
  final String heroTag;
  final Key textFormFieldKey;
  final bool withDeleteButton;
  final Function() onTextTap;
  final Function() onDeleteTap;
  final String? hint;
  final String? initialValue;

  const ReadOnlyTextFormField({
    super.key,
    required this.title,
    required this.heroTag,
    required this.textFormFieldKey,
    required this.withDeleteButton,
    required this.onTextTap,
    required this.onDeleteTap,
    this.hint,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyles.textBaseBold),
        if (hint != null) Text(hint!, style: TextStyles.textSRegularWithColor(AppColors.contentColor)),
        SizedBox(height: Margins.spacing_base),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Hero(
              tag: heroTag,
              child: Material(
                type: MaterialType.transparency,
                child: TextFormField(
                  key: textFormFieldKey,
                  style: TextStyles.textBaseBold,
                  decoration: TextFormFieldInputDecoration(),
                  readOnly: true,
                  initialValue: initialValue,
                  onTap: onTextTap,
                ),
              ),
            ),
            if (withDeleteButton)
              IconButton(
                onPressed: onDeleteTap,
                tooltip: Strings.suppressionLabel,
                icon: const Icon(Icons.close),
              ),
          ],
        ),
      ],
    );
  }
}
