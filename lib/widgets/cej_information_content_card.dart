import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';

class CejInformationFirstContentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CardContainer(
      padding: EdgeInsets.all(Margins.spacing_m),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Semantics(
              header: true,
              child: Text(
                Strings.whoIsConcerned,
                style: TextStyles.textMBold.copyWith(color: AppColors.primary),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Margins.spacing_m),
              child: Image.asset("assets/illustrations/puzzle2.webp"),
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: Strings.whoIsConcernedFirstRichText[0], style: TextStyles.textBaseRegular),
                TextSpan(text: Strings.whoIsConcernedFirstRichText[1], style: TextStyles.textBaseBold),
                TextSpan(text: Strings.whoIsConcernedFirstRichText[2], style: TextStyles.textBaseRegular),
                TextSpan(text: Strings.whoIsConcernedFirstRichText[3], style: TextStyles.textBaseBold),
                TextSpan(text: Strings.whoIsConcernedFirstRichText[4], style: TextStyles.textBaseRegular),
              ],
            ),
          ),
          SizedBox(height: Margins.spacing_m),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: Strings.whoIsConcernedSecondRichText[0], style: TextStyles.textBaseRegular),
                TextSpan(text: Strings.whoIsConcernedSecondRichText[1], style: TextStyles.textBaseBold),
                TextSpan(text: Strings.whoIsConcernedSecondRichText[2], style: TextStyles.textBaseRegular),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CejInformationSecondContentCard extends StatelessWidget {
  const CejInformationSecondContentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      padding: EdgeInsets.all(Margins.spacing_m),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: SizedBox(
              height: 200,
              width: 200,
              child: Image.asset("assets/illustrations/conversation.webp"),
            ),
          ),
          SizedBox(height: Margins.spacing_m),
          Text(
            Strings.takeRdvWithConseiller,
            style: TextStyles.textMRegular,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
