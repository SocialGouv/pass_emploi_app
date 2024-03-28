import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/chat/chat_message_container.dart';
import 'package:pass_emploi_app/widgets/text_with_clickable_links.dart';

class ChatTextMessageParams {
  final Sender sender;
  final String content;
  final String caption;
  final Color? captionColor;

  ChatTextMessageParams({
    required this.sender,
    required this.content,
    required this.caption,
    required this.captionColor,
  });
}

class ChatTextMessage extends StatelessWidget {
  final ChatTextMessageParams params;

  const ChatTextMessage(this.params);

  @override
  Widget build(BuildContext context) {
    final bool isMyMessage = params.sender == Sender.jeune;
    final TextStyle textStyle = isMyMessage
        ? TextStyles.textSRegular(color: Colors.white) //
        : TextStyles.textSRegular();
    return ChatMessageContainer(
      content: SelectableTextWithClickableLinks(
        params.content,
        linkStyle: textStyle,
        style: textStyle,
      ),
      isMyMessage: isMyMessage,
      caption: params.caption,
      captionColor: params.captionColor,
    );
  }
}
