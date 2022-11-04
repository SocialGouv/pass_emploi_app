import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/text_with_clickable_links.dart';

class ChatMessageWidget extends StatelessWidget {
  final MessageItem item;

  const ChatMessageWidget(this.item) : super();

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle =
        item is ConseillerMessageItem ? TextStyles.textSRegular() : TextStyles.textSRegular(color: Colors.white);
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
              color: item is ConseillerMessageItem ? AppColors.primaryLighten : AppColors.primary,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
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
