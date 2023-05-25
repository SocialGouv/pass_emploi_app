import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ActionsRechercheEvenementEmploiViewModel extends ActionsRechercheViewModel {
  @override
  final bool withAlertButton;
  @override
  final bool withFiltreButton;
  @override
  final int? filtresCount;

  ActionsRechercheEvenementEmploiViewModel({
    required this.withAlertButton,
    required this.withFiltreButton,
    required this.filtresCount,
  });

  factory ActionsRechercheEvenementEmploiViewModel.create(Store<AppState> store) {
    return ActionsRechercheEvenementEmploiViewModel(
      withAlertButton: false,
      withFiltreButton: false,
      filtresCount: null,
    );
  }

  @override
  List<Object?> get props => [withAlertButton, withFiltreButton, filtresCount];
}
