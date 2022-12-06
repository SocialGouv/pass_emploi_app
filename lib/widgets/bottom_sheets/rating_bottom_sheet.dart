import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/rating_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/mail_handler.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/cards/rating_card.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

final InAppReview inAppReview = InAppReview.instance;

class RatingBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RatingViewModel>(
      converter: (state) => RatingViewModel.create(state),
      builder: (context, viewModel) => _body(context, viewModel),
    );
  }

  Widget _body(BuildContext context, RatingViewModel viewModel) {
    return FractionallySizedBox(
      heightFactor: 0.4,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: _content(context, viewModel),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, RatingViewModel viewModel) {
    return Column(
      children: [
        _RatingHeader(onDismiss: viewModel.onDone),
        SepLine(0, 0),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              RatingCard(
                emoji: Strings.happyEmoji,
                description: Strings.positiveRating,
                onClick: () => _onPositiveRating(context, viewModel),
              ),
              SepLine(10, 10),
              RatingCard(
                emoji: Strings.sadEmoji,
                description: Strings.negativeRating,
                onClick: () => _onNegativeRating(context, viewModel),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onPositiveRating(BuildContext context, RatingViewModel viewModel) async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
      _ratingDone(context, viewModel, true);
    } else {
      showFailedSnackBar(context, Strings.miscellaneousErrorRetry);
    }
  }

  void _onNegativeRating(BuildContext context, RatingViewModel viewModel) async {
    final mailSent = await MailHandler.sendEmail(
        email: Strings.supportMail, subject: Strings.titleSupportMail, body: Strings.contentSupportMail);
    mailSent ? _ratingDone(context, viewModel, false) : showFailedSnackBar(context, Strings.miscellaneousErrorRetry);
  }

  void _ratingDone(BuildContext context, RatingViewModel viewModel, bool isPositive) {
    viewModel.onDone();
    Navigator.pop(context);
    _matomoTracking(isPositive ? AnalyticsActionNames.positiveRating : AnalyticsActionNames.negativeRating);
  }
}

class _RatingHeader extends StatelessWidget {
  final Function() onDismiss;

  _RatingHeader({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        IconButton(
          onPressed: () {
            onDismiss();
            _matomoTracking(AnalyticsActionNames.skipRating);
            Navigator.pop(context);
          },
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

void _matomoTracking(String action) {
  PassEmploiMatomoTracker.instance.trackScreenWithName(widgetName: AnalyticsScreenNames.ratingPage, eventName: action);
}
