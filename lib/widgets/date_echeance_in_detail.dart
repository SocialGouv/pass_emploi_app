import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class DateEcheanceInDetail extends StatelessWidget {
  final List<String> icons;
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
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          ...icons.map((icon) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SvgPicture.asset(icon, color: textColor, height: 20),
            );
          }).toList(),
          Expanded(
            child: RichText(
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
