import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/rating_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/mail_handler.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/widgets/cards/rating_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

final InAppReview inAppReview = InAppReview.instance;

class RatingPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() => MaterialPageRoute(builder: (context) => RatingPage());

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RatingViewModel>(
      converter: (state) => RatingViewModel.create(state, PlatformUtils.getPlatform),
      builder: (context, viewModel) => _Scaffold(viewModel),
      distinct: true,
    );
  }
}

class _Scaffold extends StatelessWidget {
  final RatingViewModel viewModel;

  const _Scaffold(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.ratingLabel),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(Margins.spacing_s),
          child: _Body(viewModel),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final RatingViewModel viewModel;

  const _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
}

void _sendStoreReview(BuildContext context, RatingViewModel viewModel) async {
  final isAvailable = await inAppReview.isAvailable();
  if (isAvailable) inAppReview.requestReview();
  if (!context.mounted) return;
  isAvailable ? _ratingDone(context, viewModel, true) : showSnackBarWithSystemError(context);
}

void _sendEmailReview(BuildContext context, RatingViewModel viewModel) async {
  final mailSent = await MailHandler.sendEmail(
    email: Strings.supportMail,
    object: viewModel.ratingEmailObject,
    body: Strings.contentSupportMail,
  );
  if (!context.mounted) return;
  mailSent ? _ratingDone(context, viewModel, false) : showSnackBarWithSystemError(context);
}

void _ratingDone(BuildContext context, RatingViewModel viewModel, bool isPositive) {
  viewModel.onDone();
  Navigator.pop(context);
  PassEmploiMatomoTracker.instance.trackScreen(
    isPositive ? AnalyticsActionNames.positiveRating : AnalyticsActionNames.negativeRating,
  );
}
