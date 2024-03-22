import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

class FocusedBorderBuilder extends StatefulWidget {
  FocusedBorderBuilder({
    super.key,
    required this.builder,
    this.borderColor,
    this.borderRadius,
  });

  final Widget Function(FocusNode focusNode) builder;
  final Color? borderColor;
  final double? borderRadius;

  @override
  State<FocusedBorderBuilder> createState() => _FocusedBorderBuilderState();
}

class _FocusedBorderBuilderState extends State<FocusedBorderBuilder> {
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
    return Container(
      padding: _focusNode.hasFocus ? EdgeInsets.all(2) : null,
      decoration: BoxDecoration(
        border: _focusNode.hasFocus ? Border.all(color: widget.borderColor ?? AppColors.primary, width: 2) : null,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 360),
      ),
      child: widget.builder(_focusNode),
    );
  }
}
