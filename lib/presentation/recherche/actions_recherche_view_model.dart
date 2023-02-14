import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';

abstract class ActionsRechercheViewModel extends Equatable {
  abstract final bool withAlertButton;
  abstract final bool withFiltreButton;
  abstract final int? filtresCount;
}

extension AlertButtonExtension on RechercheState {
  bool withAlertButton() => [RechercheStatus.success, RechercheStatus.updateLoading].contains(status);
}
