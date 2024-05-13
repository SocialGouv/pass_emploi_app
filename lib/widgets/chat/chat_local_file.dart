import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/chat/chat_item.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/chat/chat_message_container.dart';

class ChatLocalFile extends StatelessWidget {
  final LocalFileMessageItem message;

  const ChatLocalFile(this.message);

  @override
  Widget build(BuildContext context) {
    return ChatMessageContainer(
      caption: message.caption,
      captionColor: message.captionColor,
      captionSuffixIcon: message.captionSuffixIcon,
      isMyMessage: true,
      content: Row(
        children: [
          SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(),
          ),
          SizedBox(width: Margins.spacing_s),
          Text(message.fileName, style: TextStyles.textBaseBold.copyWith(color: Colors.white))
        ],
      ),
    );
  }
}
