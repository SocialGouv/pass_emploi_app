import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class PartageOffrePageViewModel {
  final String offreTitle;

  PartageOffrePageViewModel({required this.offreTitle});

  factory PartageOffrePageViewModel.create(Store<AppState> store) {
    final offreEmploiDetailsState = store.state.offreEmploiDetailsState;
    if (offreEmploiDetailsState is! OffreEmploiDetailsSuccessState) {
      throw Exception("PartageOffrePageViewModel must be created with a OffreEmploiDetailsSuccessState.");
    }
    return PartageOffrePageViewModel(offreTitle: offreEmploiDetailsState.offre.title);
  }
}
