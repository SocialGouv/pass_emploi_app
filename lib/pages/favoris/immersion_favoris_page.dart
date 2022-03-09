import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/analytics_extensions.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/presentation/favori_list_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/widgets/cards/data_card.dart';
import 'package:redux/redux.dart';

import '../immersion_details_page.dart';
import '../offre_page.dart';
import 'favoris_page.dart';

class ImmersionFavorisPage extends AbstractFavorisPage<Immersion, Immersion> {
  ImmersionFavorisPage()
      : super(
          selectState: (store) => store.state.immersionFavorisState,
          analyticsScreenName: AnalyticsScreenNames.immersionFavoris,
        );

  @override
  FavorisListViewModel<Immersion, Immersion> converter(Store<AppState> store) {
    return FavorisListViewModel.createForImmersion(store);
  }

  @override
  Widget item(BuildContext context, Immersion itemViewModel) {
    return DataCard<Immersion>(
      titre: itemViewModel.metier,
      sousTitre: itemViewModel.nomEtablissement,
      lieu: itemViewModel.ville,
      dataTag: [itemViewModel.secteurActivite],
      onTap: () => pushAndTrackBack(
        context,
        ImmersionDetailsPage.materialPageRoute(
          itemViewModel.id,
          popPageWhenFavoriIsRemoved: true,
        ),
      ),
      from: OffrePage.immersionFavoris,
      id: itemViewModel.id,
    );
  }
}
