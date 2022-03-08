import 'package:pass_emploi_app/features/favori/update/favori_update_middleware.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class OffreEmploiDataFromIdExtractor extends DataFromIdExtractor<OffreEmploi> {
  @override
  OffreEmploi extractFromId(Store<AppState> store, String favoriId) {
    final state = store.state.offreEmploiListState as OffreEmploiListSuccessState;
    return state.offres.firstWhere((element) => element.id == favoriId);
  }
}

class ImmersionDataFromIdExtractor extends DataFromIdExtractor<Immersion> {
  @override
  Immersion extractFromId(Store<AppState> store, String favoriId) {
    final state = store.state.immersionListState as ImmersionListSuccessState;
    return state.immersions.firstWhere((element) => element.id == favoriId);
  }
}