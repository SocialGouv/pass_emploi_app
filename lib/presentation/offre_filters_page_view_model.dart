import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class OffreFiltersPageViewModel extends Equatable {
  final List<OffreType> offreTypes;

  OffreFiltersPageViewModel({required this.offreTypes});

  factory OffreFiltersPageViewModel.create(Store<AppState> store) {
    final isCej = store.state.configurationState.getBrand().isCej;
    return OffreFiltersPageViewModel(
      offreTypes: [
        OffreType.emploi,
        if (isCej) OffreType.alternance,
        OffreType.immersion,
        if (isCej) OffreType.serviceCivique,
      ],
    );
  }

  @override
  List<Object?> get props => [offreTypes];
}
