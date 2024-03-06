import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class ChatDaySection extends StatelessWidget {
  final String dayLabel;

  const ChatDaySection({required this.dayLabel});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(dayLabel, style: TextStyles.textSRegular()));
  }
}
