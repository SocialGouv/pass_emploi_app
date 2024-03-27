import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/chat/chat_item.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class DeletedMessage extends StatelessWidget {
  const DeletedMessage(this.item);
  final DeletedMessageItem item;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: item.sender.isJeune ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: Margins.spacing_s),
        padding: EdgeInsets.symmetric(vertical: Margins.spacing_s, horizontal: Margins.spacing_base),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey500),
          borderRadius: BorderRadius.circular(Dimens.radius_base),
        ),
        child: Text(
          Strings.chatDeletedMessage,
          style: TextStyles.textSRegular(color: AppColors.grey800),
        ),
      ),
    );
  }
}
