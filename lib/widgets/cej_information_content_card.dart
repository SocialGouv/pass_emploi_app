import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CejInformationContentCard extends StatelessWidget {
  final List<Widget> children;

  const CejInformationContentCard({
    required this.children,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_m),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Dimens.radius_base)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Margins.spacing_m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

class CejInformationFirstContentCard extends StatelessWidget {
  const CejInformationFirstContentCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CejInformationContentCard(
      children: [
        Text(Strings.whyThisApp, style: TextStyles.textMBold.copyWith(color: AppColors.primary)),
        SizedBox(height: Margins.spacing_base),
        Text(Strings.whyThisAppDesc, style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_m),
        _cardBulletPoint(Drawables.icDoneCircle, Strings.customService),
        SizedBox(height: Margins.spacing_s),
        Text(Strings.customServiceDesc, style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_m),
        _cardBulletPoint(Drawables.icOnboardingChat, Strings.favoredContact),
        SizedBox(height: Margins.spacing_s),
        Text(Strings.favoredContactDesc, style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_m),
        _cardBulletPoint(Drawables.icSearch, Strings.searchTool),
        SizedBox(height: Margins.spacing_s),
        Text(Strings.searchToolDesc, style: TextStyles.textBaseRegular),
      ],
    );
  }
}

class CejInformationSecondContentCard extends StatelessWidget {
  const CejInformationSecondContentCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CejInformationContentCard(
      children: [
        Text(Strings.whatIsCej, style: TextStyles.textMBold.copyWith(color: AppColors.primary)),
        SizedBox(height: Margins.spacing_m),
        _cardBulletPoint(Drawables.icFlash, Strings.customService),
        SizedBox(height: Margins.spacing_s),
        Text(Strings.customServiceCejDesc, style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_m),
        _cardBulletPoint(Drawables.icPeople, Strings.uniqueReferent),
        SizedBox(height: Margins.spacing_s),
        Text(Strings.uniqueReferentDesc, style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_m),
        _cardBulletPoint(Drawables.icEuro, Strings.financialHelp),
        SizedBox(height: Margins.spacing_s),
        Text(Strings.financialHelpDesc, style: TextStyles.textBaseRegular),
      ],
    );
  }
}

class CejInformationThirdContentCard extends StatelessWidget {
  const CejInformationThirdContentCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CejInformationContentCard(
      children: [
        Text(Strings.whoIsConcerned, style: TextStyles.textMBold.copyWith(color: AppColors.primary)),
        SizedBox(height: Margins.spacing_m),
        SvgPicture.asset(Drawables.puzzle),
        SizedBox(height: Margins.spacing_m),
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
    );
  }
}

Widget _cardBulletPoint(String icon, String text) {
  return RichText(
    text: TextSpan(
      children: [
        WidgetSpan(
          child: Padding(
            padding: const EdgeInsets.only(right: Margins.spacing_s),
            child: SvgPicture.asset(icon),
          ),
        ),
        TextSpan(text: text, style: TextStyles.textBaseBold),
      ],
    ),
  );
}
