import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class ChatMessageContainer extends StatelessWidget {
  const ChatMessageContainer({
    super.key,
    required this.content,
    required this.caption,
    required this.captionColor,
    required this.isMyMessage,
  });
  final Widget content;
  final String caption;
  final Color? captionColor;
  final bool isMyMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          _ChatBubble(
            isMyMessage: isMyMessage,
            child: content,
          ),
          _Caption(caption, captionColor),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.isMyMessage, required this.child});
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
        color: isMyMessage ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: child,
    );
  }
}

class _Caption extends StatelessWidget {
  final String text;
  final Color? color;

  const _Caption(this.text, this.color) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Margins.spacing_xs),
        Text(text, style: TextStyles.textXsRegular().copyWith(color: color)),
      ],
    );
  }
}
