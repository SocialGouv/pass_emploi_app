import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/chat/chat_item.dart';
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
              _CopyMessageButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CopyMessageButton extends StatelessWidget {
  const _CopyMessageButton();

  @override
  Widget build(BuildContext context) {
    return _ChatBottomSheetButton(
      icon: AppIcons.content_copy_rounded,
      text: Strings.chatCopyMessage,
      onPressed: () {}, //TODO:
    );
  }
}

class _ChatBottomSheetButton extends StatelessWidget {
  const _ChatBottomSheetButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text, style: TextStyles.textBaseBold),
      onTap: onPressed,
    );
  }
}
