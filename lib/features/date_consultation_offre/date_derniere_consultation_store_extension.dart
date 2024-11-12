import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

extension DateDerniereConsultationStoreExtension on Store<AppState> {
  DateTime? getOffreDateDerniereConsultationOrNull(String offreId) {
    final state = this.state.dateConsultationOffreState;
    return state.offreIdToDateConsultation[offreId];
  }
}
