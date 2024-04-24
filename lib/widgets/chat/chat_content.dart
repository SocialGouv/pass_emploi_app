import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/chat/chat_list_view.dart';
import 'package:pass_emploi_app/widgets/chat/chat_text_field.dart';
import 'package:pass_emploi_app/widgets/chat/empty_chat_placeholder.dart';

class ChatContent extends StatefulWidget {
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
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: widget.reversedItems.isEmpty
              ? EmptyChatPlaceholder()
              : SingleChildScrollView(
                  reverse: true,
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: widget.scrollController,
                  child: Column(
                    children: [
                      ChatListView(
                        reversedItems: widget.reversedItems,
                        itemBuilder: widget.itemBuilder,
                      ),
                      if (widget.messageImportant != null)
                        _MessageImportantItem(
                          message: widget.messageImportant!,
                          focusNode: _focusNode,
                        ),
                    ],
                  ),
                ),
        ),
        ChatTextField(
          controller: widget.controller,
          focusNode: _focusNode,
          onSendMessage: widget.onSendMessage,
          onSendImage: widget.onSendImage,
          jeunePjEnabled: widget.jeunePjEnabled,
        )
      ],
    );
  }
}

class _MessageImportantItem extends StatefulWidget {
  const _MessageImportantItem({required this.message, required this.focusNode});
  final String message;
  final FocusNode focusNode;

  @override
  State<_MessageImportantItem> createState() => _MessageImportantItemState();
}

class _MessageImportantItemState extends State<_MessageImportantItem> {
  bool isKeyboardVisible = true;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(listener);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(listener);
    super.dispose();
  }

  void listener() {
    final hasFocus = widget.focusNode.hasFocus;
    setState(() {
      isKeyboardVisible = hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    const foregroundColor = AppColors.grey100;
    if (isKeyboardVisible) {
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
          Expanded(child: Text(widget.message, style: TextStyles.textSRegular(color: foregroundColor))),
        ],
      ),
    );
  }
}
