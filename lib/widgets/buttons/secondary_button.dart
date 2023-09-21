import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class SecondaryButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final double? fontSize;

  const SecondaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor = Colors.transparent,
    this.fontSize,
  }) : super(key: key);

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseTextStyle = TextStyles.textSecondaryButton;
    final usedTextStyle = widget.fontSize != null ? baseTextStyle.copyWith(fontSize: widget.fontSize) : baseTextStyle;
    return Container(
      padding: _focusNode.hasFocus ? EdgeInsets.all(2) : null,
      margin: !_focusNode.hasFocus ? EdgeInsets.all(2) : null,
      decoration: BoxDecoration(
        color: _focusNode.hasFocus ? Colors.white : widget.backgroundColor,
        border: Border.all(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.circular(360),
      ),
      child: TextButton(
        focusNode: _focusNode,
        onPressed: widget.onPressed,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          textStyle: MaterialStateProperty.all(usedTextStyle),
          backgroundColor: MaterialStateProperty.all<Color?>(widget.backgroundColor),
          alignment: Alignment.center,
          shape:
              MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(200)))),
          side: MaterialStateProperty.resolveWith<BorderSide>((Set<MaterialState> states) {
            if (_focusNode.hasFocus) {
              return BorderSide(color: AppColors.primary, width: 2);
            }
            return BorderSide.none;
          }),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacing_base),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null)
                Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      widget.icon,
                      color: AppColors.primary,
                      size: Dimens.icon_size_base,
                    )),
              Flexible(child: Text(widget.label, textAlign: TextAlign.center, style: usedTextStyle)),
            ],
          ),
        ),
      ),
    );
  }
}
