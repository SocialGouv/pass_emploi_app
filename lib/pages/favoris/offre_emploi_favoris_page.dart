import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/solution_type.dart';
import 'package:pass_emploi_app/pages/favoris/favoris_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/presentation/favori_list_view_model.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/cards/favori_card.dart';
import 'package:pass_emploi_app/widgets/tags/tags.dart';
import 'package:redux/redux.dart';

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
    return FavoriCard<OffreEmploi>.likable(
      title: itemViewModel.title,
      company: itemViewModel.companyName,
      place: itemViewModel.location,
      bottomTip: Strings.voirLeDetail,
      solutionType: SolutionType.OffreEmploi,
      from: onlyAlternance ? OffrePage.alternanceFavoris : OffrePage.emploiFavoris,
      id: itemViewModel.id,
      dataTags: _buildTags(itemViewModel),
      onTap: () => Navigator.push(
        context,
        OffreEmploiDetailsPage.materialPageRoute(
          itemViewModel.id,
          fromAlternance: onlyAlternance,
          popPageWhenFavoriIsRemoved: true,
        ),
      ),
    );
  }

  List<Widget> _buildTags(OffreEmploiItemViewModel itemViewModel) {
    final Widget contractTypeTag = DataTag(
      label: itemViewModel.contractType,
      icon: AppIcons.description_rounded,
    );

    final Widget durationTag = itemViewModel.duration != null
        ? DataTag(
            label: itemViewModel.duration!,
            icon: AppIcons.schedule_rounded,
          )
        : SizedBox.shrink();
    return [contractTypeTag, durationTag];
  }
}
