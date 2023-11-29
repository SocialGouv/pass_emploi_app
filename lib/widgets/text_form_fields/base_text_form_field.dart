import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class BaseTextF extends StatelessWidget {
  final bool isEnabled;
  final String? errorText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final int? minLines;
  final int? maxLines;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isInvalid;
  final bool autofocus;
  final String? hintText;

  const BaseTextF({
    super.key,
    this.isEnabled = true,
    this.errorText,
    this.textInputAction,
    this.onChanged,
    this.minLines,
    this.maxLines,
    this.controller,
    this.keyboardType = TextInputType.multiline,
    this.isInvalid = false,
    this.autofocus = false,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyles.textSRegular(),
        contentPadding: const EdgeInsets.all(Margins.spacing_base),
        errorText: errorText,
        border: isInvalid ? _errorBorder() : _idleBorder(),
        focusedBorder: isInvalid ? _errorBorder() : _focusedBorder(),
      ),
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: textInputAction,
      style: TextStyles.textBaseRegular,
      onChanged: onChanged,
      enabled: isEnabled,
      minLines: minLines,
      maxLines: maxLines,
    );
  }

  OutlineInputBorder _idleBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimens.radius_base),
      borderSide: BorderSide(color: AppColors.contentColor, width: 1.0),
    );
  }

  OutlineInputBorder _focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimens.radius_base),
      borderSide: BorderSide(color: AppColors.primary, width: 2.0),
    );
  }

  OutlineInputBorder _errorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimens.radius_base),
      borderSide: BorderSide(color: AppColors.warning, width: 2.0),
    );
  }
}
