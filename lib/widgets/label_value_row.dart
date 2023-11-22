import 'package:flutter/material.dart';

class LabelValueRow extends StatelessWidget {
  final Widget label;
  final Widget value;

  const LabelValueRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        label,
        value,
      ],
    );
  }
}
