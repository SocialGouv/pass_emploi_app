import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/features/offres_suivies/offres_suivies_actions.dart';
import 'package:pass_emploi_app/features/offres_suivies/offres_suivies_state.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class OffreSuivieBottomSheetViewModel extends Equatable {
  final void Function() onCloseBottomSheet;
  final void Function() onPostule;
  final void Function() onInteresse;

  OffreSuivieBottomSheetViewModel({
    required this.onCloseBottomSheet,
    required this.onPostule,
    required this.onInteresse,
  });

  factory OffreSuivieBottomSheetViewModel.create(Store<AppState> store, String offreId) {
    final offreSuivie = store.state.offresSuiviesState.getOffre(offreId);
    if (offreSuivie == null) OffreSuivieBottomSheetViewModel.empty();
    return OffreSuivieBottomSheetViewModel(
      onCloseBottomSheet: () => store.dispatch(OffresSuiviesDeleteAction(offreSuivie!)),
      onPostule: () => store.dispatch(FavoriUpdateRequestAction<OffreEmploi>(offreId, FavoriStatus.postulated)),
      onInteresse: () => store.dispatch(FavoriUpdateRequestAction<OffreEmploi>(offreId, FavoriStatus.added)),
    );
  }

  factory OffreSuivieBottomSheetViewModel.empty() {
    return OffreSuivieBottomSheetViewModel(
      onCloseBottomSheet: () {},
      onPostule: () {},
      onInteresse: () {},
    );
  }

  @override
  List<Object?> get props => [];
}
