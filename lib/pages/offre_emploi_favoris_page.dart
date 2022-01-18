import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/presentation/favoris_list_view_model.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/widgets/offre_emploi_list_item.dart';
import 'package:redux/redux.dart';

import 'favoris_page.dart';
import 'offre_emploi_details_page.dart';
import 'offre_page.dart';

class OffreEmploiFavorisPage extends AbstractFavorisPage<OffreEmploi, OffreEmploiItemViewModel> {
  final bool onlyAlternance;

  OffreEmploiFavorisPage({required this.onlyAlternance})
      : super(
          analyticsScreenName:
              onlyAlternance ? AnalyticsScreenNames.alternanceFavoris : AnalyticsScreenNames.emploiFavoris,
          key: ValueKey(onlyAlternance),
        );

  @override
  FavorisListViewModel<OffreEmploi, OffreEmploiItemViewModel> converter(Store<AppState> store) {
    return FavorisListViewModel.createForOffreEmploi(store, onlyAlternance: onlyAlternance);
  }

  @override
  MaterialPageRoute detailsPageRoute(OffreEmploiItemViewModel itemViewModel) {
    return OffreEmploiDetailsPage.materialPageRoute(
      itemViewModel.id,
      fromAlternance: onlyAlternance,
      shouldPopPageWhenFavoriIsRemoved: true,
    );
  }

  @override
  Widget item(OffreEmploiItemViewModel itemViewModel) {
    return OffreEmploiListItem(
      itemViewModel: itemViewModel,
      from: onlyAlternance ? OffrePage.alternanceFavoris : OffrePage.emploiFavoris,
    );
  }
}
