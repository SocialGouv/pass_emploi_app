import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_store_extension.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DemarcheDetailBottomSheetViewModel {
  final bool withDemarcheCancelButton;
  final void Function() onDemarcheCancel;

  DemarcheDetailBottomSheetViewModel({
    required this.withDemarcheCancelButton,
    required this.onDemarcheCancel,
  });

  factory DemarcheDetailBottomSheetViewModel.create(Store<AppState> store, String demarcheId) {
    final demarche = store.getDemarcheOrNull(demarcheId);

    if (demarche == null) {
      return DemarcheDetailBottomSheetViewModel(
        withDemarcheCancelButton: false,
        onDemarcheCancel: () {},
      );
    }

    return DemarcheDetailBottomSheetViewModel(
      withDemarcheCancelButton: demarche.possibleStatus.contains(DemarcheStatus.CANCELLED),
      onDemarcheCancel: () => store.dispatch(
        UpdateDemarcheRequestAction(
          id: demarche.id,
          dateFin: demarche.endDate,
          dateDebut: demarche.creationDate,
          status: DemarcheStatus.CANCELLED,
        ),
      ),
    );
  }
}
