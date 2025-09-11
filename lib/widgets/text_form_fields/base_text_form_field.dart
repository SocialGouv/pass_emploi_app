import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class BaseTextField extends StatefulWidget {
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
  State<BaseTextField> createState() => _BaseTextFieldState();
}

class _BaseTextFieldState extends State<BaseTextField> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();

    _controller.addListener(_validateText);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      maxLength: widget.maxLength,
      initialValue: widget.initialValue,
      onTap: widget.onTap,
      onFieldSubmitted: widget.onFieldSubmitted,
      showCursor: widget.showCursor,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        semanticCounterText: "",
        hintStyle: TextStyles.textSRegular(color: AppColors.grey800),
        contentPadding: const EdgeInsets.all(Margins.spacing_base),
        error: widget.errorText != null
            ? _Error(widget.errorText!)
            : _errorText != null
                ? _Error(_errorText!)
                : null,
        border: widget.isInvalid ? _errorBorder() : _idleBorder(),
        focusedBorder: widget.isInvalid ? _errorBorder() : _focusedBorder(),
        errorBorder: _errorBorder(),
        focusedErrorBorder: _errorBorder(),
        enabledBorder: widget.isInvalid ? _errorBorder() : _idleBorder(),
      ),
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      style: TextStyles.textBaseRegular,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
    );
  }

  void _validateText() {
    final value = _controller.text;
    setState(() {
      if (widget.maxLength != null && value.length >= widget.maxLength!) {
        _errorText = Strings.fieldMaxLengthExceeded(widget.maxLength!);
      } else {
        _errorText = null;
      }
    });
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
    return Semantics(
      focusable: true,
      focused: true,
      child: Row(
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
      ),
    );
  }
}
