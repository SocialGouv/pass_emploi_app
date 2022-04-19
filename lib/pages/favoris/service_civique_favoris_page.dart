import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/analytics_extensions.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/pages/favoris/favoris_page.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_detail_page.dart';
import 'package:pass_emploi_app/presentation/favori_list_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';
import 'package:pass_emploi_app/widgets/cards/data_card.dart';
import 'package:redux/redux.dart';

class ServiceCiviqueFavorisPage extends AbstractFavorisPage<ServiceCivique, ServiceCivique> {
  ServiceCiviqueFavorisPage()
      : super(
          selectState: (store) => store.state.serviceCiviqueFavorisState,
          analyticsScreenName: AnalyticsScreenNames.immersionFavoris,
        );

  @override
  FavorisListViewModel<ServiceCivique, ServiceCivique> converter(Store<AppState> store) {
    return FavorisListViewModel.createForServiceCivique(store);
  }

  @override
  Widget item(BuildContext context, ServiceCivique itemViewModel) {
    return DataCard<ServiceCivique>(
      titre: itemViewModel.title,
      sousTitre: itemViewModel.companyName,
      lieu: itemViewModel.location,
      dataTag: [
        if (itemViewModel.startDate != null)
          Strings.asSoonAs + itemViewModel.startDate!.toDateTimeUtcOnLocalTimeZone().toDayWithFullMonth()
      ],
      onTap: () {
        pushAndTrackBack(
          context,
          MaterialPageRoute(builder: (_) {
            return ServiceCiviqueDetailPage(itemViewModel.id, true);
          }),
          AnalyticsScreenNames.immersionFavoris,
        );
      },
      from: OffrePage.serviceCiviqueFavoris,
      id: itemViewModel.id,
    );
  }
}
