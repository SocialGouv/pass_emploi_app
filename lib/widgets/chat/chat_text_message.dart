import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/chat/chat_message_container.dart';
import 'package:pass_emploi_app/widgets/text_with_clickable_links.dart';

class ChatTextMessage extends StatelessWidget {
  final TextMessageItem item;

  const ChatTextMessage(this.item) : super();

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle =
        item is ConseillerTextMessageItem ? TextStyles.textSRegular() : TextStyles.textSRegular(color: Colors.white);
    return ChatMessageContainer(
      content: SelectableTextWithClickableLinks(
        item.content,
        linkStyle: textStyle,
        style: textStyle,
      ),
      isMyMessage: item is JeuneTextMessageItem,
      caption: item.caption,
    );
  }
}
