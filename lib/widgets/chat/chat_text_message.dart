import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/chat/chat_bubble_widget.dart';
import 'package:pass_emploi_app/widgets/text_with_clickable_links.dart';

class ChatTextMessage extends StatelessWidget {
  final TextMessageItem item;

  const ChatTextMessage(this.item) : super();

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle =
        item is ConseillerTextMessageItem ? TextStyles.textSRegular() : TextStyles.textSRegular(color: Colors.white);
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: item is ConseillerTextMessageItem ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          ChatBubble(
            isMyMessage: item is JeuneTextMessageItem,
            child: SelectableTextWithClickableLinks(
              item.content,
              linkStyle: textStyle,
              style: textStyle,
            ),
          ),
          SizedBox(height: Margins.spacing_xs),
          Text(item.caption, style: TextStyles.textXsRegular())
        ],
      ),
    );
  }
}
