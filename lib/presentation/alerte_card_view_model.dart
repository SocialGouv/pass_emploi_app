import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/alerte/get/alerte_get_action.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class AlerteCardViewModel extends Equatable {
  final Function(Alerte) fetchAlerteResult;

  AlerteCardViewModel({
    required this.fetchAlerteResult,
  });

  static AlerteCardViewModel create(Store<AppState> store) {
    return AlerteCardViewModel(
      fetchAlerteResult: (alerte) => store.dispatch(FetchAlerteResultsAction(alerte)),
    );
  }

  @override
  List<Object?> get props => [];
}
