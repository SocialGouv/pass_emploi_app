import 'package:flutter/material.dart';
import 'package:pass_emploi_app/widgets/chat/chat_list_view.dart';
import 'package:pass_emploi_app/widgets/chat/chat_text_field.dart';
import 'package:pass_emploi_app/widgets/chat/empty_chat_placeholder.dart';

class ChatContent extends StatelessWidget {
  final List<dynamic> reversedItems;
  final ScrollController scrollController;
  final TextEditingController controller;
  final Function(String) onSendMessage;
  final NullableIndexedWidgetBuilder itemBuilder;

  const ChatContent({
    required this.reversedItems,
    required this.controller,
    required this.scrollController,
    required this.onSendMessage,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        reversedItems.isEmpty
            ? EmptyChatPlaceholder()
            : ChatListView(
                controller: scrollController,
                reversedItems: reversedItems,
                itemBuilder: itemBuilder,
              ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ChatTextField(
            controller: controller,
            onSendMessage: onSendMessage,
          ),
        )
      ],
    );
  }
}
