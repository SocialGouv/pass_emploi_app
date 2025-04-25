import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class RechercheHomePageViewModel extends Equatable {
  final List<OffreType> offreTypes;

  RechercheHomePageViewModel({required this.offreTypes});

  factory RechercheHomePageViewModel.create(Store<AppState> store) {
    final accompagnement = store.state.accompagnement();
    return RechercheHomePageViewModel(
      offreTypes: [
        OffreType.emploi,
        if ([Accompagnement.cej, Accompagnement.aij, Accompagnement.avenirPro].contains(accompagnement))
          OffreType.alternance,
        OffreType.immersion,
        if ([Accompagnement.cej, Accompagnement.aij, Accompagnement.avenirPro].contains(accompagnement))
          OffreType.serviceCivique,
      ],
    );
  }

  @override
  List<Object?> get props => [offreTypes];
}
