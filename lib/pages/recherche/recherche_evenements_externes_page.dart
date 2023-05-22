import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_page.dart';
import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_resultat_recherche_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/evenements_externes/actions_recherche_evenements_externes_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/cards/rendezvous_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/recherche/criteres_recherche_evenements_externes_contenu.dart';
import 'package:redux/redux.dart';

class RechercheEvenementsExternesPage extends RechercheOffrePage<Rendezvous> {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => RechercheEvenementsExternesPage());
  }

  RechercheEvenementsExternesPage();

  static Widget withPrimaryAppBar() {
    const backgroundColor = AppColors.grey100;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PrimaryAppBar(title: Strings.eventAppBarTitle, backgroundColor: backgroundColor),
      body: RechercheEvenementsExternesPage(),
    );
  }

  @override
  ActionsRechercheViewModel buildActionsRechercheViewModel(Store<AppState> store) {
    return ActionsRechercheEvenementsExternesViewModel.create(store);
  }

  @override
  String? appBarTitle() => null;

  //TODO: analytics
  @override
  String analyticsType() => "evenements_externes";

  @override
  RechercheState rechercheState(AppState appState) => appState.rechercheEvenementsExternesState;

  @override
  FavoriIdsState<Rendezvous> favorisState(AppState appState) => FavoriIdsState<Rendezvous>.notInitialized();

  @override
  Widget buildAlertBottomSheet() => SizedBox.shrink();

  @override
  Route<bool>? buildFiltresMaterialPageRoute() => null;

  @override
  Widget buildCriteresContentWidget({required Function(int) onNumberOfCriteresChanged}) {
    return CriteresRechercheEvenementsExternesContenu(onNumberOfCriteresChanged: onNumberOfCriteresChanged);
  }

  @override
  Widget buildResultItem(
    BuildContext context,
    Rendezvous item,
    int index,
    BlocResultatRechercheViewModel<Rendezvous> resultViewModel,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_s),
      child: item.id.rendezvousCard(
        context: context,
        stateSource: RendezvousStateSource.evenementsExternes,
        trackedEvent: EventType.RDV_DETAIL,
        simpleCard: false,
      ),
    );
  }
}
