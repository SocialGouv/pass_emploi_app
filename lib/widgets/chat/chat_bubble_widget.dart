import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

class ChatBubbleWidget extends StatelessWidget {
  const ChatBubbleWidget({super.key, required this.isMyMessage, required this.child});
  final bool isMyMessage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: isMyMessage ? 77.0 : 0,
        right: !isMyMessage ? 77.0 : 0,
      ),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isMyMessage ? AppColors.primary : AppColors.primaryLighten,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: child,
    );
  }
}
