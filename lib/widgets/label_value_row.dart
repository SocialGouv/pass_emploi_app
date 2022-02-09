import 'package:flutter/material.dart';

class LabelValueRow extends StatelessWidget {
  final Widget label;
  final Widget value;

  const LabelValueRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.spaceBetween,
      spacing: 4,
      children: [label, value],
    );
  }
}
