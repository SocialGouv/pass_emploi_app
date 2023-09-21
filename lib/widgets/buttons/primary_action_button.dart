import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class PrimaryActionButton extends StatefulWidget {
  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color textColor;
  final Color? rippleColor;
  final Color? iconColor;
  final IconData? icon;
  final String label;
  final bool withShadow;
  final VoidCallback? onPressed;
  final double? fontSize;
  final double iconSize;
  final double iconRightPadding;
  final double heightPadding;
  final double widthPadding;

  PrimaryActionButton({
    Key? key,
    Color? backgroundColor,
    this.disabledBackgroundColor = AppColors.primaryWithAlpha50,
    this.textColor = Colors.white,
    this.rippleColor = AppColors.primaryDarken,
    this.iconColor = Colors.white,
    this.withShadow = true,
    this.icon,
    this.onPressed,
    required this.label,
    this.fontSize,
    this.iconSize = Dimens.icon_size_m,
    this.iconRightPadding = 8,
    this.heightPadding = 16,
    this.widthPadding = 24,
  })  : backgroundColor = backgroundColor ?? AppColors.primary,
        super(key: key);

  @override
  State<PrimaryActionButton> createState() => _PrimaryActionButtonState();
}

class _PrimaryActionButtonState extends State<PrimaryActionButton> {
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
    final baseTextStyle = TextStyles.textPrimaryButton;
    final usedTextStyle = widget.fontSize != null ? baseTextStyle.copyWith(fontSize: widget.fontSize) : baseTextStyle;
    return Container(
      padding: _focusNode.hasFocus ? EdgeInsets.all(2) : null,
      margin: !_focusNode.hasFocus ? EdgeInsets.all(2) : null,
      decoration: BoxDecoration(
        color: _focusNode.hasFocus ? Colors.white : widget.backgroundColor,
        border: Border.all(color: _focusNode.hasFocus ? AppColors.primary : Colors.transparent, width: 2),
        borderRadius: BorderRadius.circular(360),
      ),
      child: TextButton(
        focusNode: _focusNode,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          foregroundColor: MaterialStateProperty.all(widget.textColor),
          textStyle: MaterialStateProperty.all(usedTextStyle),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            return states.contains(MaterialState.disabled) ? widget.disabledBackgroundColor : widget.backgroundColor;
          }),
          elevation: MaterialStateProperty.resolveWith((states) {
            return (states.contains(MaterialState.disabled) || !widget.withShadow) ? 0 : 10;
          }),
          alignment: Alignment.center,
          shape:
              MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(200)))),
          overlayColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.pressed)) {
                return widget.rippleColor;
              }
              return null;
            },
          ),
        ),
        onPressed: widget.onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.widthPadding, vertical: widget.heightPadding),
          child: _getRow(),
        ),
      ),
    );
  }

  Widget _getRow() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (widget.icon != null)
          Padding(
            padding: EdgeInsets.only(right: widget.iconRightPadding),
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: widget.iconColor,
            ),
          ),
        Text(
          widget.label,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
