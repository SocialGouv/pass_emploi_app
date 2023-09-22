import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

class FocusedBorderBuilder extends StatefulWidget {
  const FocusedBorderBuilder({super.key, required this.builder, required this.bgColor});

  final Widget Function(FocusNode focusNode) builder;
  final Color bgColor;

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
        color: _focusNode.hasFocus ? Colors.white : widget.bgColor,
        border: _focusNode.hasFocus ? Border.all(color: AppColors.primary, width: 2) : null,
        borderRadius: BorderRadius.circular(360),
      ),
      child: widget.builder(_focusNode),
    );
  }
}
