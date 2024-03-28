import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/rating_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';
import 'package:pass_emploi_app/widgets/rating_page.dart';

class AccueilRatingAppCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RatingViewModel>(
      converter: (store) => RatingViewModel.create(store, PlatformUtils.getPlatform),
      builder: (context, viewModel) => _Body(viewModel),
    );
  }
}

class _Body extends StatelessWidget {
  final RatingViewModel viewModel;

  const _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      backgroundColor: AppColors.primary,
      splashColor: AppColors.primaryDarken.withOpacity(0.5),
      padding: EdgeInsets.zero,
      onTap: () => Navigator.push(context, RatingPage.materialPageRoute()),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: Margins.spacing_base, horizontal: Margins.spacing_m),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  AppIcons.hotel_class,
                  color: Colors.white,
                  size: Dimens.icon_size_l,
                ),
                SizedBox(width: Margins.spacing_m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Strings.ratingAppLabel,
                        style: TextStyles.textMBold.copyWith(color: Colors.white),
                      ),
                      SizedBox(height: Margins.spacing_base),
                      PressedTip(
                        Strings.ratingButton,
                        textColor: Colors.white,
                        icon: AppIcons.chevron_right_rounded,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              tooltip: Strings.close,
              onPressed: () {
                viewModel.onDone();
                PassEmploiMatomoTracker.instance.trackScreen(AnalyticsActionNames.skipRating);
              },
              icon: Icon(AppIcons.close_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
