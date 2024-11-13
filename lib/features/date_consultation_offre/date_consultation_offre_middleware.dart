import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/date_consultation_offre/date_consultation_offre_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/date_consultation_offre_repository.dart';
import 'package:redux/redux.dart';

class DateConsultationOffreMiddleware extends MiddlewareClass<AppState> {
  final DateConsultationOffreRepository _repository;

  DateConsultationOffreMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is BootstrapAction) {
      final offreIdToDateConsultation = await _repository.get();
      store.dispatch(DateConsultationUpdateAction(offreIdToDateConsultation));
    }

    if (action is DateConsultationWriteOffreAction) {
      final date = DateTime.now();
      await _repository.set(action.offreId, date);
      final offreIdToDateConsultation =
          Map<String, DateTime>.from(store.state.dateConsultationOffreState.offreIdToDateConsultation);
      offreIdToDateConsultation[action.offreId] = date;
      store.dispatch(DateConsultationUpdateAction(offreIdToDateConsultation));
    }
  }
}
