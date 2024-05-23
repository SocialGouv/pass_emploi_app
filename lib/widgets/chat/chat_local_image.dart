import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/chat/chat_item.dart';
import 'package:pass_emploi_app/widgets/chat/chat_message_container.dart';

class ChatLocalImage extends StatelessWidget {
  const ChatLocalImage(this.message);
  final LocalImageMessageItem message;

  @override
  Widget build(BuildContext context) {
    return ChatMessageContainer(
      caption: message.caption,
      captionColor: message.captionColor,
      captionSuffixIcon: message.captionSuffixIcon,
      isMyMessage: true,
      isPj: true,
      content: Stack(
        alignment: Alignment.center,
        children: [
          Expanded(child: Image.file(File(message.imagePath))),
          SizedBox.square(
            dimension: 40,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
