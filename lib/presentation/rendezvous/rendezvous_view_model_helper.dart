import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

String takeTypeLabelOrPrecision(Rendezvous rdv) {
  return (rdv.type.code == RendezvousTypeCode.AUTRE && rdv.precision != null) ? rdv.precision! : rdv.type.label;
}

Rendezvous getRendezvousFromStore(Store<AppState> store, String rdvId) {
  final state = store.state.rendezvousState;
  if (state is! RendezvousSuccessState) throw Exception('Rendezvous state is not successful');
  if (state.rendezvous.where((e) => e.id == rdvId).isEmpty) throw Exception('No Rendezvous matching id $rdvId');
  return state.rendezvous.firstWhere((e) => e.id == rdvId);
}
