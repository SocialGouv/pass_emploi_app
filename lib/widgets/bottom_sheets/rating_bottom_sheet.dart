import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/rating_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/mail_handler.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/widgets/cards/rating_card.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

final InAppReview inAppReview = InAppReview.instance;

class RatingBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RatingViewModel>(
      converter: (state) => RatingViewModel.create(state, io.Platform.isAndroid ? Platform.ANDROID : Platform.IOS),
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
                onClick: () => _sendStoreReview(context, viewModel),
              ),
              SepLine(10, 10),
              RatingCard(
                emoji: Strings.sadEmoji,
                description: Strings.negativeRating,
                onClick: () => viewModel.shouldSendEmailOnNegativeRating
                    ? _sendEmailReview(context, viewModel)
                    : _sendStoreReview(context, viewModel),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _sendStoreReview(BuildContext context, RatingViewModel viewModel) async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
      _ratingDone(context, viewModel, true);
    } else {
      showFailedSnackBar(context, Strings.miscellaneousErrorRetry);
    }
  }

  void _sendEmailReview(BuildContext context, RatingViewModel viewModel) async {
    final mailSent = await MailHandler.sendEmail(
        email: Strings.supportMail, subject: Strings.titleSupportMail, body: Strings.contentSupportMail);
    mailSent ? _ratingDone(context, viewModel, false) : showFailedSnackBar(context, Strings.miscellaneousErrorRetry);
  }

  void _ratingDone(BuildContext context, RatingViewModel viewModel, bool isPositive) {
    viewModel.onDone();
    Navigator.pop(context);
    PassEmploiMatomoTracker.instance.trackScreen(
      isPositive ? AnalyticsActionNames.positiveRating : AnalyticsActionNames.negativeRating,
    );
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
            PassEmploiMatomoTracker.instance.trackScreen(AnalyticsActionNames.skipRating);
            Navigator.pop(context);
          },
          tooltip: Strings.close,
          icon: Icon(AppIcons.close_rounded, color: AppColors.contentColor),
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
