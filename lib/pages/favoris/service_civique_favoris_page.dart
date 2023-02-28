import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/solution_type.dart';
import 'package:pass_emploi_app/pages/favoris/favoris_page.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_detail_page.dart';
import 'package:pass_emploi_app/presentation/favori_list_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';
import 'package:pass_emploi_app/widgets/cards/favori_card.dart';
import 'package:pass_emploi_app/widgets/tags/tags.dart';
import 'package:redux/redux.dart';

class ServiceCiviqueFavorisPage extends AbstractFavorisPage<ServiceCivique, ServiceCivique> {
  ServiceCiviqueFavorisPage()
      : super(
          selectState: (store) => store.state.serviceCiviqueFavorisState,
          analyticsScreenName: AnalyticsScreenNames.immersionDetails, //TODO-1434 Delete
        );

  @override
  FavorisListViewModel<ServiceCivique, ServiceCivique> converter(Store<AppState> store) {
    return FavorisListViewModel.createForServiceCivique(store);
  }

  @override
  Widget item(BuildContext context, ServiceCivique itemViewModel) {
    final Widget dataTag = itemViewModel.startDate != null
        ? DataTag(
            label: Strings.asSoonAs + itemViewModel.startDate!.toDateTimeUtcOnLocalTimeZone().toDayWithFullMonth(),
            icon: AppIcons.today_rounded)
        : SizedBox.shrink();
    return FavoriCard<ServiceCivique>.likable(
      title: itemViewModel.title,
      company: itemViewModel.companyName,
      place: itemViewModel.location,
      bottomTip: Strings.voirLeDetail,
      solutionType: SolutionType.ServiceCivique,
      from: OffrePage.serviceCiviqueDetails,
      //TODO-1434 Delete
      id: itemViewModel.id,
      dataTags: [dataTag],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) {
            return ServiceCiviqueDetailPage(itemViewModel.id, true);
          }),
        );
      },
    );
  }
}
