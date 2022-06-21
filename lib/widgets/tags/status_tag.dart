import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class StatutTag extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String title;

  const StatutTag({
    Key? key,
    required this.backgroundColor,
    required this.textColor,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        color: backgroundColor,
        border: Border.all(color: textColor),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Text(
        title,
        style: TextStyles.textSRegularWithColor(textColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
