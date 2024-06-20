import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class RechercheHomePageViewModel extends Equatable {
  final List<OffreType> offreTypes;
  final bool shouldShowOnboarding;

  RechercheHomePageViewModel({required this.offreTypes, required this.shouldShowOnboarding});

  factory RechercheHomePageViewModel.create(Store<AppState> store) {
    final accompagnement = store.state.accompagnement();
    return RechercheHomePageViewModel(
      offreTypes: [
        OffreType.emploi,
        if ([Accompagnement.cej, Accompagnement.aij].contains(accompagnement)) OffreType.alternance,
        OffreType.immersion,
        if ([Accompagnement.cej, Accompagnement.aij].contains(accompagnement)) OffreType.serviceCivique,
      ],
      shouldShowOnboarding: _shouldShowOnboarding(store),
    );
  }

  @override
  List<Object?> get props => [offreTypes, shouldShowOnboarding];
}

bool _shouldShowOnboarding(Store<AppState> store) {
  return store.state.onboardingState.showRechercheOnboarding;
}
