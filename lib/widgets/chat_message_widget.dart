import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class ChatMessageWidget extends StatelessWidget {
  final MessageItem item;

  const ChatMessageWidget(this.item) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: item is ConseillerMessageItem ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: item is JeuneMessageItem ? 77.0 : 0,
              right: item is ConseillerMessageItem ? 77.0 : 0,
            ),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: item is ConseillerMessageItem ? AppColors.lightBlue : AppColors.nightBlue,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Text(
              item.content,
              style: TextStyles.textSmRegular(
                color: item is ConseillerMessageItem ? AppColors.nightBlue : Colors.white,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(item.hourLabel, style: TextStyles.textXsRegular())
        ],
      ),
    );
  }
}
