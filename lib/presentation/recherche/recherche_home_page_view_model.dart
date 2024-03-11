import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class RechercheHomePageViewModel extends Equatable {
  final List<OffreType> offreTypes;
  final bool shouldShowOnboarding;

  RechercheHomePageViewModel({required this.offreTypes, required this.shouldShowOnboarding});

  factory RechercheHomePageViewModel.create(Store<AppState> store) {
    final isCej = store.state.configurationState.getBrand().isCej;
    return RechercheHomePageViewModel(
      offreTypes: [
        OffreType.emploi,
        if (isCej) OffreType.alternance,
        OffreType.immersion,
        if (isCej) OffreType.serviceCivique,
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
