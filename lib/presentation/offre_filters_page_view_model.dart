import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/solution_type.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class OffreFiltersPageViewModel extends Equatable {
  final List<SolutionType> solutionTypes;

  OffreFiltersPageViewModel({required this.solutionTypes});

  factory OffreFiltersPageViewModel.create(Store<AppState> store) {
    final isCej = store.state.configurationState.getBrand().isCej;
    return OffreFiltersPageViewModel(
      solutionTypes: [
        SolutionType.OffreEmploi,
        SolutionType.Alternance,
        if (isCej) SolutionType.Immersion,
        if (isCej) SolutionType.ServiceCivique,
      ],
    );
  }

  @override
  List<Object?> get props => [solutionTypes];
}
