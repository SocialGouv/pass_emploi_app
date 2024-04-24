import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/chat/chat_list_view.dart';
import 'package:pass_emploi_app/widgets/chat/chat_text_field.dart';
import 'package:pass_emploi_app/widgets/chat/empty_chat_placeholder.dart';

class ChatContent extends StatelessWidget {
  final List<dynamic> reversedItems;
  final ScrollController scrollController;
  final TextEditingController controller;
  final Function(String) onSendMessage;
  final Function(String imagePath) onSendImage;
  final bool jeunePjEnabled;
  final NullableIndexedWidgetBuilder itemBuilder;
  final String? messageImportant;

  const ChatContent({
    required this.reversedItems,
    required this.controller,
    required this.scrollController,
    required this.onSendMessage,
    required this.onSendImage,
    required this.jeunePjEnabled,
    required this.itemBuilder,
    this.messageImportant,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: reversedItems.isEmpty
              ? EmptyChatPlaceholder()
              : SingleChildScrollView(
                  reverse: true,
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: scrollController,
                  child: Column(
                    children: [
                      ChatListView(
                        reversedItems: reversedItems,
                        itemBuilder: itemBuilder,
                      ),
                      if (messageImportant != null) _MessageImportantItem(messageImportant!),
                    ],
                  ),
                ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ChatTextField(
            controller: controller,
            onSendMessage: onSendMessage,
            onSendImage: onSendImage,
            jeunePjEnabled: jeunePjEnabled,
          ),
        )
      ],
    );
  }
}

class _MessageImportantItem extends StatelessWidget {
  const _MessageImportantItem(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    const foregroundColor = AppColors.grey100;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    if (isKeyboardOpen) {
      return SizedBox.shrink();
    }
    return Container(
      padding: EdgeInsets.all(Margins.spacing_base),
      decoration: BoxDecoration(
        color: AppColors.disabled,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(AppIcons.info_rounded, color: foregroundColor),
          SizedBox(width: Margins.spacing_s),
          Expanded(child: Text(message, style: TextStyles.textSRegular(color: foregroundColor))),
        ],
      ),
    );
  }
}
