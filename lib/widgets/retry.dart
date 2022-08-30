import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class Retry extends StatelessWidget {
  final String text;
  final VoidCallback onRetry;

  const Retry(this.text, this.onRetry) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, textAlign: TextAlign.center),
        TextButton(onPressed: onRetry, child: Text(Strings.retry, style: TextStyles.textSecondaryButton)),
      ],
    );
  }
}
