import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';

class ChatAttachedFileWidget extends StatelessWidget {
  final AttachedFileConseillerMessageItem item;

  const ChatAttachedFileWidget(this.item) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 0,
              right: 77.0,
            ),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.primaryLighten,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.message, style: TextStyles.textSRegular()),
                SizedBox(height: 14),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(padding: const EdgeInsets.only(right: 10), child: SvgPicture.asset(Drawables.icClip)),
                    Flexible(
                      child: Text(
                        item.filename,
                        style: TextStyles.textSBoldWithColor(Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: PrimaryActionButton(
                    label: Strings.download,
                    drawableRes: Drawables.icDownload,
                    onPressed: () => {},
                    heightPadding: 2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Margins.spacing_xs),
          Text(item.caption, style: TextStyles.textXsRegular()),
        ],
      ),
    );
  }
}
