import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/solution_type.dart';
import 'package:pass_emploi_app/pages/favoris/favoris_page.dart';
import 'package:pass_emploi_app/pages/immersion_details_page.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/presentation/favori_list_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/cards/favori_card.dart';
import 'package:pass_emploi_app/widgets/tags/tags.dart';
import 'package:redux/redux.dart';

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
    final Widget dataTag = DataTag(label: itemViewModel.secteurActivite);
    return FavoriCard<Immersion>.likable(
      title: itemViewModel.metier,
      place: itemViewModel.ville,
      bottomTip: Strings.voirLeDetail,
      solutionType: SolutionType.Immersion,
      from: OffrePage.immersionFavoris,
      id: itemViewModel.id,
      dataTags: [dataTag],
      onTap: () => Navigator.push(
        context,
        ImmersionDetailsPage.materialPageRoute(
          itemViewModel.id,
          popPageWhenFavoriIsRemoved: true,
        ),
      ),
    );
  }
}
