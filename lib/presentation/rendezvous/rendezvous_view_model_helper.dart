import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

String takeTypeLabelOrPrecision(Rendezvous rdv) {
  return (rdv.type.code == RendezvousTypeCode.AUTRE && rdv.precision != null) ? rdv.precision! : rdv.type.label;
}

Rendezvous getRendezvousFromStore(Store<AppState> store, String rdvId) {
  final state = store.state.rendezvousState;
  final rendezvous = state.rendezvous.where((e) => e.id == rdvId);
  if (rendezvous.isEmpty) throw Exception('No Rendezvous matching id $rdvId');
  return rendezvous.first;
}
