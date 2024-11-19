import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/derniere_offre_consultee/derniere_offre_consultee_actions.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_state.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/models/offre_dto.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/derniere_offre_consultee_repository.dart';
import 'package:redux/redux.dart';

class DerniereOffreConsulteeMiddleware extends MiddlewareClass<AppState> {
  final DerniereOffreConsulteeRepository _repository;

  DerniereOffreConsulteeMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is BootstrapAction) {
      final offre = await _repository.get();
      if (offre != null) {
        store.dispatch(DerniereOffreConsulteeUpdateAction(offre));
      }
    }

    if (action is DerniereOffreEmploiConsulteeWriteAction) {
      final offreEmploiDetailState = store.state.offreEmploiDetailsState;
      if (offreEmploiDetailState is OffreEmploiDetailsSuccessState) {
        final offre = OffreEmploiDto(offreEmploiDetailState.offre.toOffreEmploi);
        await _repository.set(offre);
        store.dispatch(DerniereOffreConsulteeUpdateAction(offre));
      }
    }

    if (action is DerniereOffreImmersionConsulteeWriteAction) {
      final offreImmersionDetailState = store.state.immersionDetailsState;
      if (offreImmersionDetailState is ImmersionDetailsSuccessState) {
        final offre = OffreImmersionDto(offreImmersionDetailState.immersion.toImmersion);
        await _repository.set(offre);
        store.dispatch(DerniereOffreConsulteeUpdateAction(offre));
      }
    }

    if (action is DerniereOffreServiceCiviqueConsulteeWriteAction) {
      final offreServiceCiviqueDetailState = store.state.serviceCiviqueDetailState;
      if (offreServiceCiviqueDetailState is ServiceCiviqueDetailSuccessState) {
        final offre = OffreServiceCiviqueDto(offreServiceCiviqueDetailState.detail.toServiceCivique);
        await _repository.set(offre);
        store.dispatch(DerniereOffreConsulteeUpdateAction(offre));
      }
    }
  }
}
