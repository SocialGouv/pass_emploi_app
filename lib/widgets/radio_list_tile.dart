import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CustomRadioGroup<T> extends StatelessWidget {
  const CustomRadioGroup(
      {super.key, required this.title, required this.value, required this.groupValue, required this.onChanged});
  final String title;
  final T value;
  final T? groupValue;
  final void Function(T?) onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      activeColor: AppColors.primary,
      title: Text(title, style: TextStyles.textBaseMedium),
      controlAffinity: ListTileControlAffinity.leading,
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
