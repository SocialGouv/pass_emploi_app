import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/a11y/string_a11y_extensions.dart';

class ChatMessageContainer extends StatelessWidget {
  const ChatMessageContainer({
    super.key,
    required this.content,
    required this.caption,
    required this.captionColor,
    required this.isMyMessage,
    required this.isPj,
    this.captionSuffixIcon,
  });

  final Widget content;
  final String caption;
  final Color? captionColor;
  final bool isMyMessage;
  final bool isPj;
  final IconData? captionSuffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          _ChatBubble(
            isPj: isPj,
            isMyMessage: isMyMessage,
            child: content,
          ),
          Row(
            mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Caption(caption, captionColor),
              if (captionSuffixIcon != null) ...[
                SizedBox(width: Margins.spacing_s),
                Padding(
                  padding: const EdgeInsets.only(top: Margins.spacing_xs),
                  child: Icon(captionSuffixIcon, color: captionColor),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.isMyMessage, required this.child, required this.isPj});

  final bool isPj;
  final bool isMyMessage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isMyMessage ? Strings.chatA11yMessageFromMe : Strings.chatA11yMessageFromMyConseiller,
      child: Container(
        margin: EdgeInsets.only(
          left: isMyMessage ? 77.0 : 0,
          right: !isMyMessage ? 77.0 : 0,
        ),
        padding: EdgeInsets.all(isPj ? Margins.spacing_s : Margins.spacing_base),
        decoration: BoxDecoration(
          color: isMyMessage ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: child,
      ),
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
        Text(
          text,
          style: TextStyles.textXsRegular().copyWith(color: color),
          semanticsLabel: text.toTimeAndDurationForScreenReaders(),
        ),
      ],
    );
  }
}
