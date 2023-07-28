import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/rating_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/mail_handler.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/widgets/cards/rating_card.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

final InAppReview inAppReview = InAppReview.instance;

class RatingPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() => MaterialPageRoute(builder: (context) => RatingPage());

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RatingViewModel>(
      converter: (state) => RatingViewModel.create(state, PlatformUtils.getPlatform),
      builder: (context, viewModel) => _body(context, viewModel),
    );
  }

  Widget _body(BuildContext context, RatingViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: _RatingAppBar(onDismiss: viewModel.onDone),
        centerTitle: false,
      ),
      body: Center(
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
        Expanded(
          child: Semantics(
            label: Strings.listSemanticsLabel,
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

class _RatingAppBar extends StatelessWidget {
  final Function() onDismiss;

  _RatingAppBar({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(Strings.ratingLabel, style: TextStyles.textBaseBold, textAlign: TextAlign.center),
    );
  }
}
