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
import 'package:pass_emploi_app/widgets/buttons/debounced_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_icon_button.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';

class FavoriHeart<T> extends StatelessWidget {
  final String offreId;
  final bool withBorder;
  final OffrePage from;
  final Function()? onFavoriRemoved;

  FavoriHeart({
    required this.offreId,
    required this.withBorder,
    required this.from,
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
      builder: (context, viewModel) => _buildHeart(context, viewModel),
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

  Widget _buildHeart(BuildContext context, FavoriHeartViewModel<T> viewModel) {
    return Tooltip(
      message: viewModel.isFavori ? Strings.favoriHeartRemove : Strings.favoriHeartAdd,
      child: DebouncedButton(
        childBuilder: (onTapDebounced) => SecondaryIconButton(
          icon: viewModel.isFavori ? AppIcons.favorite_rounded : AppIcons.favorite_outline_rounded,
          iconColor: AppColors.favoriteHeartColor,
          borderColor: withBorder ? AppColors.primary : Colors.transparent,
          onTap: onTapDebounced,
        ),
        onTap: () {
          viewModel.update(viewModel.isFavori ? FavoriStatus.removed : FavoriStatus.added);
          _sendTracking(viewModel.isFavori);
        },
      ),
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
    switch (from) {
      case OffrePage.emploiResults:
        return AnalyticsActionNames.emploiResultUpdateFavori(isFavori);
      case OffrePage.emploiDetails:
        return AnalyticsActionNames.emploiDetailUpdateFavori(isFavori);
      case OffrePage.alternanceResults:
        return AnalyticsActionNames.alternanceResultUpdateFavori(isFavori);
      case OffrePage.alternanceDetails:
        return AnalyticsActionNames.alternanceDetailUpdateFavori(isFavori);
      case OffrePage.immersionResults:
        return AnalyticsActionNames.immersionResultUpdateFavori(isFavori);
      case OffrePage.immersionDetails:
        return AnalyticsActionNames.immersionDetailUpdateFavori(isFavori);
      case OffrePage.serviceCiviqueResults:
        return AnalyticsActionNames.serviceCiviqueResultUpdateFavori(isFavori);
      case OffrePage.serviceCiviqueDetails:
        return AnalyticsActionNames.serviceCiviqueDetailUpdateFavori(isFavori);
      case OffrePage.offreFavoris:
        return AnalyticsActionNames.offreFavoriUpdateFavori(isFavori);
    }
  }
}
