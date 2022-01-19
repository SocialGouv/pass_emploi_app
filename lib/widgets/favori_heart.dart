import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/presentation/favori_heart_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/favoris_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';
import 'package:pass_emploi_app/widgets/secondary_icon_button.dart';

abstract class FavoriHeart<T> extends StatelessWidget {
  final String offreId;
  final bool withBorder;
  final OffrePage from;
  final Function()? onFavoriRemoved;

  FavoriHeart({required this.offreId, required this.withBorder, required this.from, this.onFavoriRemoved}) : super();

  FavorisState<T> selectState(Store<AppState> store);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FavoriHeartViewModel>(
      converter: (store) => FavoriHeartViewModel<T>.create(offreId, store, selectState(store)),
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

  Widget _buildHeart(BuildContext context, FavoriHeartViewModel viewModel) {
    return SecondaryIconButton(
      drawableRes: viewModel.isFavori ? Drawables.icHeartFull : Drawables.icHeart,
      iconColor: AppColors.favoriteHeartColor,
      borderColor: withBorder ? AppColors.primary : Colors.transparent,
      onTap: () {
        viewModel.update(!viewModel.isFavori);
        _sendTracking(viewModel.isFavori);
      },
    );
  }

  void _sendTracking(bool isFavori) {
    final newFavoriStatus = !isFavori;
    final widgetName = FavoriHeartAnalyticsHelper().getAnalyticsWidgetName(from, newFavoriStatus);
    final eventName = FavoriHeartAnalyticsHelper().getAnalyticsEventName(from);
    if (widgetName != null && eventName != null) MatomoTracker.trackScreenWithName(widgetName, eventName);
  }
}

class FavoriHeartAnalyticsHelper {
  String? getAnalyticsWidgetName(OffrePage from, bool isFavori) {
    switch (from) {
      case OffrePage.emploiResults:
        return AnalyticsActionNames.emploiResultUpdateFavori(isFavori);
      case OffrePage.emploiDetails:
        return AnalyticsActionNames.emploiDetailUpdateFavori(isFavori);
      case OffrePage.emploiFavoris:
        return AnalyticsActionNames.emploiFavoriUpdateFavori(isFavori);
      case OffrePage.alternanceResults:
        return AnalyticsActionNames.alternanceResultUpdateFavori(isFavori);
      case OffrePage.alternanceDetails:
        return AnalyticsActionNames.alternanceDetailUpdateFavori(isFavori);
      case OffrePage.alternanceFavoris:
        return AnalyticsActionNames.alternanceFavoriUpdateFavori(isFavori);
    }
  }

  String? getAnalyticsEventName(OffrePage from) {
    switch (from) {
      case OffrePage.emploiResults:
        return AnalyticsScreenNames.emploiResults;
      case OffrePage.emploiDetails:
        return AnalyticsScreenNames.emploiDetails;
      case OffrePage.emploiFavoris:
        return AnalyticsScreenNames.emploiFavoris;
      case OffrePage.alternanceResults:
        return AnalyticsScreenNames.alternanceResults;
      case OffrePage.alternanceDetails:
        return AnalyticsScreenNames.alternanceDetails;
      case OffrePage.alternanceFavoris:
        return AnalyticsScreenNames.alternanceFavoris;
    }
  }
}

class OffreEmploiFavoriHeart extends FavoriHeart<OffreEmploi> {
  OffreEmploiFavoriHeart({required offreId, required withBorder, required from, onFavoriRemoved})
      : super(offreId: offreId, withBorder: withBorder, from: from, onFavoriRemoved: onFavoriRemoved);

  @override
  FavorisState<OffreEmploi> selectState(Store<AppState> store) {
    return store.state.offreEmploiFavorisState;
  }
}