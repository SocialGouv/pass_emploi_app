import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_state.dart';

RendezvousListState rendezvousListReducer(RendezvousListState current, dynamic action) {
  if (action is RendezvousListLoadingAction) {
    if (action.period == RendezvousPeriod.FUTUR) {
      return current.copyWith(futurRendezVousStatus: RendezvousListStatus.LOADING);
    } else {
      return current.copyWith(pastRendezVousStatus: RendezvousListStatus.LOADING);
    }
  }
  if (action is RendezvousListReloadingAction) {
    if (action.period == RendezvousPeriod.FUTUR) {
      return current.copyWith(futurRendezVousStatus: RendezvousListStatus.RELOADING, dateDerniereMiseAJour: () => null);
    } else {
      return current.copyWith(pastRendezVousStatus: RendezvousListStatus.RELOADING, dateDerniereMiseAJour: () => null);
    }
  }
  if (action is RendezvousListFailureAction) {
    if (action.period == RendezvousPeriod.FUTUR) {
      return current.copyWith(futurRendezVousStatus: RendezvousListStatus.FAILURE);
    } else {
      return current.copyWith(pastRendezVousStatus: RendezvousListStatus.FAILURE);
    }
  }
  if (action is RendezvousListSuccessAction) {
    if (action.period == RendezvousPeriod.FUTUR) {
      return current.copyWith(
        futurRendezVousStatus: RendezvousListStatus.SUCCESS,
        rendezvous: action.rendezvousListResult.rendezvous,
        sessionsMilo: action.sessionsMilo,
        dateDerniereMiseAJour: () => action.rendezvousListResult.dateDerniereMiseAJour,
      );
    } else {
      final rendezvous = action.rendezvousListResult.rendezvous + current.rendezvous;
      final sessions = action.sessionsMilo + current.sessionsMilo;
      return current.copyWith(
        pastRendezVousStatus: RendezvousListStatus.SUCCESS,
        rendezvous: rendezvous,
        sessionsMilo: sessions,
        dateDerniereMiseAJour: () => action.rendezvousListResult.dateDerniereMiseAJour,
      );
    }
  }
  if (action is RendezvousListResetAction) return RendezvousListState.notInitialized();
  return current;
}
