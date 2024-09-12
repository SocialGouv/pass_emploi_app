import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class DateEcheanceInDetail extends StatelessWidget {
  final List<IconData> icons;
  final List<FormattedText> formattedTexts;
  final Color textColor;
  final Color backgroundColor;

  DateEcheanceInDetail({
    required this.icons,
    required this.formattedTexts,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Dimens.radius_base),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          ...icons.map((icon) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(icon, color: textColor, size: Dimens.icon_size_m),
            );
          }),
          Expanded(
            child: RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                children: formattedTexts.map((text) {
                  return TextSpan(
                    text: text.value,
                    style: text.bold
                        ? TextStyles.textBaseBoldWithColor(textColor)
                        : TextStyles.textSRegularWithColor(textColor),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
