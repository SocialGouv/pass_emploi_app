import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/rating_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/rating_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

void ratingSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.only(left: 24, bottom: 14),
      duration: Duration(days: 365),
      backgroundColor: Colors.white,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _DismissSnackBar(),
          _SnackBarTittle(),
          _OnRatingTap(),
        ],
      ),
    ),
  );
}

class _DismissSnackBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RatingViewModel>(
      converter: (store) => RatingViewModel.create(store),
      builder: (context, viewModel) => _body(context, viewModel),
    );
  }

  Widget _body(BuildContext context, RatingViewModel viewModel) {
    return InkWell(
      onTap: () => _onDismiss(context, viewModel),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 5, 0),
        child: Icon(AppIcons.close_rounded, color: AppColors.contentColor),
      ),
    );
  }

  void _onDismiss(BuildContext context, RatingViewModel viewModel) {
    viewModel.onDone();
    snackbarKey.currentState?.hideCurrentSnackBar();
    PassEmploiMatomoTracker.instance.trackScreen(AnalyticsActionNames.skipRating);
  }
}

class _SnackBarTittle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 40, 0, 15),
        child: Text(
          Strings.ratingLabel,
          style: TextStyles.textBaseRegular,
        ),
      ),
    );
  }
}

class _OnRatingTap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        snackbarKey.currentState?.hideCurrentSnackBar();
        showPassEmploiBottomSheet(context: context, builder: (context) => RatingBottomSheet());
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 50, 35, 0),
        child: Icon(AppIcons.chevron_right_rounded, color: AppColors.contentColor),
      ),
    );
  }
}
