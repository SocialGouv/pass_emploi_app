import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/chat_edit_message_page.dart';
import 'package:pass_emploi_app/presentation/chat/chat_item.dart';
import 'package:pass_emploi_app/presentation/chat/chat_message_bottom_sheet_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';

class ChatMessageBottomSheet extends StatelessWidget {
  const ChatMessageBottomSheet({super.key, required this.chatItem});
  final ChatItem chatItem;

  static void show(BuildContext context, ChatItem chatItem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ChatMessageBottomSheet(chatItem: chatItem),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ChatMessageBottomSheetViewModel>(
        converter: (store) => ChatMessageBottomSheetViewModel.create(store, chatItem.messageId),
        builder: (context, viewModel) {
          return BottomSheetWrapper(
            heightFactor: 0.4,
            body: SizedBox(
              width: double.infinity,
              child: OverflowBox(
                maxHeight: double.infinity,
                maxWidth: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Divider(color: AppColors.grey100),
                    _CopyMessageButton(viewModel.content),
                    if (viewModel.withEditOption) _EditMessageButton(viewModel.onEdit, viewModel.content),
                    if (viewModel.withDeleteOption) _DeleteMessageButton(viewModel.onDelete),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class _CopyMessageButton extends StatelessWidget {
  const _CopyMessageButton(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return _ChatBottomSheetButton(
      icon: AppIcons.content_copy_rounded,
      text: Strings.chatCopyMessage,
      onPressed: () {
        Clipboard.setData(ClipboardData(text: text)) //
            .then((value) => Navigator.pop(context));
      },
    );
  }
}

class _EditMessageButton extends StatelessWidget {
  const _EditMessageButton(this.onEditMessage, this.content);
  final void Function(String) onEditMessage;
  final String content;

  @override
  Widget build(BuildContext context) {
    return _ChatBottomSheetButton(
      icon: AppIcons.edit_rounded,
      text: Strings.chatEditMessage,
      withNavigationSuffix: true,
      onPressed: () async {
        final updatedContent = await Navigator.of(context).push(ChatEditMessagePage.route(content));
        if (updatedContent != null) {
          onEditMessage(updatedContent);
          Future.delayed(Duration.zero, () => Navigator.pop(context));
        }
      },
    );
  }
}

class _DeleteMessageButton extends StatelessWidget {
  const _DeleteMessageButton(this.onDelete);
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return _ChatBottomSheetButton(
      icon: AppIcons.delete,
      text: Strings.chatDeleteMessage,
      color: AppColors.warning,
      onPressed: () {
        onDelete();
        Future.delayed(Duration.zero, () => Navigator.pop(context));
      },
    );
  }
}

class _ChatBottomSheetButton extends StatelessWidget {
  const _ChatBottomSheetButton({
    required this.icon,
    required this.text,
    required this.onPressed,
    this.withNavigationSuffix = false,
    this.color,
  });
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final bool withNavigationSuffix;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyles.textBaseBold.copyWith(color: color)),
      trailing: withNavigationSuffix ? Icon(AppIcons.chevron_right_rounded) : null,
      onTap: onPressed,
    );
  }
}
