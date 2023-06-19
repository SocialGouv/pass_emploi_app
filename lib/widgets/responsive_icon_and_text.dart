import 'package:flutter/material.dart';

/// Does not display the icon if the text has not enough space
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
