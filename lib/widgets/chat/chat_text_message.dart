import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:pass_emploi_app/presentation/chat/chat_item.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/chat/chat_message_container.dart';
import 'package:pass_emploi_app/widgets/text_with_clickable_links.dart';

class ChatTextMessage extends StatelessWidget {
  final TextMessageItem item;

  const ChatTextMessage(this.item);

  @override
  Widget build(BuildContext context) {
    final bool isMyMessage = item.sender == Sender.jeune;
    final TextStyle textStyle = isMyMessage ? TextStyles.textSRegular(color: Colors.white) : TextStyles.textSRegular();
    return ChatMessageContainer(
      content: SelectableTextWithClickableLinks(
        item.content,
        linkStyle: textStyle,
        style: textStyle,
      ),
      isMyMessage: isMyMessage,
      caption: item.caption,
      captionColor: item.captionColor,
    );
  }
}
