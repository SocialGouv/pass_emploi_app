import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/rating_card.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

final InAppReview inAppReview = InAppReview.instance;

class RatingBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.4,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: _content(context),
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        _RatingHeader(),
        SepLine(0, 0),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              RatingCard(
                  emoji: Strings.happyEmoji,
                  description: Strings.positiveRating,
                  onClick: () async {
                    if (await inAppReview.isAvailable()) {
                      inAppReview.requestReview();
                    }
                  }),
              SepLine(10, 10),
              RatingCard(emoji: Strings.sadEmoji, description: Strings.negativeRating, onClick: () {}),
            ],
          ),
        ),
      ],
    );
  }
}

class _RatingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          tooltip: Strings.close,
          icon: SvgPicture.asset(Drawables.icClose, color: AppColors.contentColor),
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Text(Strings.ratingLabel, style: TextStyles.textBaseBold, textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}
