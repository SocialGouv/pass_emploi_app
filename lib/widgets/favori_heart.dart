import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/presentation/favori_heart_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/onboarding/onboarding_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/buttons/debounced_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_icon_button.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';

class FavoriHeart<T> extends StatelessWidget {
  final String offreId;
  final bool withBorder;
  final OffrePage from;
  final String a11yLabel;
  final Function()? onFavoriRemoved;

  FavoriHeart({
    required this.offreId,
    required this.withBorder,
    required this.from,
    this.a11yLabel = ' ',
    this.onFavoriRemoved,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FavoriHeartViewModel<T>>(
      converter: (store) => FavoriHeartViewModel<T>.create(
        offreId,
        store,
        context.dependOnInheritedWidgetOfExactType<FavorisStateContext<T>>()!.selectState(store),
      ),
      builder: (context, viewModel) => _buildOffreEnregistreButton(context, viewModel),
      distinct: true,
      onDidChange: (_, viewModel) {
        if (viewModel.withError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(Strings.miscellaneousErrorRetry),
            duration: Duration(seconds: 2),
          ));
        }
        if (!viewModel.isFavori) {
          onFavoriRemoved?.call();
        }
      },
    );
  }

  Widget _buildOffreEnregistreButton(BuildContext context, FavoriHeartViewModel<T> viewModel) {
    return DebouncedButton(
      childBuilder: (onTapDebounced) => SecondaryIconButton(
        icon: viewModel.isFavori ? AppIcons.bookmark_remove : AppIcons.bookmark,
        tooltip:
            viewModel.isFavori ? Strings.offreEnregistreeRemove(a11yLabel) : Strings.offreEnregistreeAdd(a11yLabel),
        iconColor: AppColors.primary,
        borderColor: withBorder ? AppColors.primary : Colors.transparent,
        onTap: onTapDebounced,
      ),
      onTap: () {
        if (viewModel.withOnboarding) {
          OnboardingBottomSheet.show(context, source: OnboardingSource.offresEnregistrees);
        }
        viewModel.update(viewModel.isFavori ? FavoriStatus.removed : FavoriStatus.added);
        _sendTracking(viewModel.isFavori);
      },
    );
  }

  void _sendTracking(bool isFavori) {
    final newFavoriStatus = !isFavori;
    final widgetName = FavoriHeartAnalyticsHelper().getAnalyticsWidgetName(from, newFavoriStatus);
    if (widgetName != null) PassEmploiMatomoTracker.instance.trackScreen(widgetName);
  }
}

class FavoriHeartAnalyticsHelper {
  String? getAnalyticsWidgetName(OffrePage from, bool isFavori) {
    return switch (from) {
      OffrePage.emploiResults => AnalyticsActionNames.emploiResultUpdateFavori(isFavori),
      OffrePage.emploiDetails => AnalyticsActionNames.emploiDetailUpdateFavori(isFavori),
      OffrePage.alternanceResults => AnalyticsActionNames.alternanceResultUpdateFavori(isFavori),
      OffrePage.alternanceDetails => AnalyticsActionNames.alternanceDetailUpdateFavori(isFavori),
      OffrePage.immersionResults => AnalyticsActionNames.immersionResultUpdateFavori(isFavori),
      OffrePage.immersionDetails => AnalyticsActionNames.immersionDetailUpdateFavori(isFavori),
      OffrePage.serviceCiviqueResults => AnalyticsActionNames.serviceCiviqueResultUpdateFavori(isFavori),
      OffrePage.serviceCiviqueDetails => AnalyticsActionNames.serviceCiviqueDetailUpdateFavori(isFavori),
      OffrePage.offreFavoris => AnalyticsActionNames.offreFavoriUpdateFavori(isFavori)
    };
  }
}
