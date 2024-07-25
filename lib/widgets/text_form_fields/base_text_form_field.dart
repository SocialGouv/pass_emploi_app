import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class BaseTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enabled;
  final String? errorText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final int? minLines;
  final int? maxLines;
  final TextInputType keyboardType;
  final bool isInvalid;
  final bool autofocus;
  final String? hintText;
  final int? maxLength;
  final String? initialValue;
  final void Function()? onTap;
  final dynamic Function(String)? onFieldSubmitted;
  final bool? showCursor;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;

  const BaseTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.errorText,
    this.textInputAction,
    this.onChanged,
    this.minLines,
    this.maxLines,
    this.keyboardType = TextInputType.multiline,
    this.isInvalid = false,
    this.autofocus = false,
    this.hintText,
    this.maxLength,
    this.initialValue,
    this.onTap,
    this.onFieldSubmitted,
    this.showCursor,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.textCapitalization = TextCapitalization.sentences,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      maxLength: maxLength,
      initialValue: initialValue,
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      showCursor: showCursor,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintStyle: TextStyles.textSRegular(color: AppColors.grey800),
        contentPadding: const EdgeInsets.all(Margins.spacing_base),
        error: errorText != null ? _Error(errorText!) : null,
        border: isInvalid ? _errorBorder() : _idleBorder(),
        focusedBorder: isInvalid ? _errorBorder() : _focusedBorder(),
        errorBorder: _errorBorder(),
        focusedErrorBorder: _errorBorder(),
      ),
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      style: TextStyles.textBaseRegular,
      onChanged: onChanged,
      enabled: enabled,
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

class _Error extends StatelessWidget {
  const _Error(this.errorText);

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          AppIcons.error_rounded,
          color: AppColors.warning,
        ),
        SizedBox(width: Margins.spacing_s),
        Expanded(
          child: Text(
            errorText,
            style: TextStyle(
              color: AppColors.warning,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
