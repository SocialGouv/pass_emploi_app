import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/analytics_extensions.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/presentation/favori_list_view_model.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/widgets/cards/data_card.dart';
import 'package:redux/redux.dart';

import '../offre_emploi_details_page.dart';
import '../offre_page.dart';
import 'favoris_page.dart';

class OffreEmploiFavorisPage extends AbstractFavorisPage<OffreEmploi, OffreEmploiItemViewModel> {
  final bool onlyAlternance;

  OffreEmploiFavorisPage({required this.onlyAlternance})
      : super(
          selectState: (store) => store.state.offreEmploiFavorisState,
          analyticsScreenName:
              onlyAlternance ? AnalyticsScreenNames.alternanceFavoris : AnalyticsScreenNames.emploiFavoris,
          key: ValueKey(onlyAlternance),
        );

  @override
  FavorisListViewModel<OffreEmploi, OffreEmploiItemViewModel> converter(Store<AppState> store) {
    return FavorisListViewModel.createForOffreEmploi(store, onlyAlternance: onlyAlternance);
  }

  @override
  Widget item(BuildContext context, OffreEmploiItemViewModel itemViewModel) {
    return DataCard<OffreEmploi>(
      titre: itemViewModel.title,
      sousTitre: itemViewModel.companyName,
      lieu: itemViewModel.location,
      dataTag: [itemViewModel.contractType, itemViewModel.duration].whereType<String>().toList(),
      id: itemViewModel.id,
      from: onlyAlternance ? OffrePage.alternanceFavoris : OffrePage.emploiFavoris,
      onTap: () => pushAndTrackBack(
        context,
        OffreEmploiDetailsPage.materialPageRoute(
          itemViewModel.id,
          fromAlternance: onlyAlternance,
          popPageWhenFavoriIsRemoved: true,
        ),
      ),
    );
  }
}
