import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/user_action_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/tags.dart';

class UserActionListItem extends StatelessWidget {
  final UserActionViewModel item;

  const UserActionListItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (item.tag != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: DataTag(
                    label: item.tag!.title,
                  )),
            ),
          if (item.tag != null) SizedBox(height: 4),
          Text(
            item.content,
            style: TextStyles.textSmMedium(),
          ),
          SizedBox(height: 4),
          if (item.withComment) ...[
            Text(item.comment, style: TextStyles.textSmRegular()),
            SizedBox(height: 4),
          ],
          Text(item.lastUpdate, style: TextStyles.textSmRegular(color: AppColors.nightBlue))
        ],
      ),
    );
  }
}
