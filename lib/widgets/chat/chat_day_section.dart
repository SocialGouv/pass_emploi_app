import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/a11y/string_a11y_extensions.dart';

class ChatDaySection extends StatelessWidget {
  final String dayLabel;

  const ChatDaySection({required this.dayLabel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        header: true,
        child: Text(
          dayLabel,
          style: TextStyles.textSRegular(),
          semanticsLabel: dayLabel.toDateForScreenReaders(),
        ),
      ),
    );
  }
}
