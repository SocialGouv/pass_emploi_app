import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class PrimaryActionButton extends StatelessWidget {
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
    this.iconRightPadding = 12,
    this.heightPadding = 12,
    this.widthPadding = 20,
  })  : backgroundColor = backgroundColor ?? AppColors.primary,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final double leftPadding = icon != null ? 12 : 20;
    final baseTextStyle = TextStyles.textPrimaryButton;
    final usedTextStyle = fontSize != null ? baseTextStyle.copyWith(fontSize: fontSize) : baseTextStyle;
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(textColor),
        textStyle: MaterialStateProperty.all(usedTextStyle),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          return states.contains(MaterialState.disabled) ? disabledBackgroundColor : backgroundColor;
        }),
        elevation: MaterialStateProperty.resolveWith((states) {
          return (states.contains(MaterialState.disabled) || !withShadow) ? 0 : 10;
        }),
        alignment: Alignment.center,
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(200)))),
        overlayColor: MaterialStateProperty.resolveWith(
          (states) {
            return states.contains(MaterialState.pressed) ? rippleColor : null;
          },
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.fromLTRB(leftPadding, heightPadding, widthPadding, heightPadding),
        child: _getRow(),
      ),
    );
  }

  Widget _getRow() {
    return ResponsiveIconText(
      icon: (key) => icon != null
          ? Padding(
              key: key,
              padding: EdgeInsets.only(right: iconRightPadding),
              child: Icon(
                icon,
                size: iconSize,
                color: iconColor,
              ),
            )
          : SizedBox.shrink(key: key),
      text: (key) => Text(
        label,
        key: key,
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Does not display the icon if the text has not enough space
class ResponsiveIconText extends StatefulWidget {
  final Widget Function(Key) icon;
  final Widget Function(Key) text;

  const ResponsiveIconText({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  _ResponsiveIconTextState createState() => _ResponsiveIconTextState();
}

class _ResponsiveIconTextState extends State<ResponsiveIconText> {
  final GlobalKey _iconKey = GlobalKey();
  final GlobalKey _textKey = GlobalKey();

  late Widget _icon;
  late Widget _text;

  @override
  void initState() {
    super.initState();
    _icon = widget.icon(_iconKey);
    _text = widget.text(_textKey);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final RenderBox? iconRenderBox = _iconKey.currentContext?.findRenderObject() as RenderBox?;
        final RenderBox? textRenderBox = _textKey.currentContext?.findRenderObject() as RenderBox?;

        final double iconWidth = iconRenderBox?.size.width ?? 0;
        final double textWidth = textRenderBox?.size.width ?? 0;

        return (iconWidth + textWidth <= constraints.maxWidth)
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _icon,
                  _text,
                ],
              )
            : _text;
      },
    );
  }
}
