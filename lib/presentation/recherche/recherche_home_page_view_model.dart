import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/solution_type.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class RechercheHomePageViewModel extends Equatable {
  final List<SolutionType> solutionTypes;

  RechercheHomePageViewModel({required this.solutionTypes});

  factory RechercheHomePageViewModel.create(Store<AppState> store) {
    final isCej = store.state.configurationState.getBrand().isCej;
    return RechercheHomePageViewModel(
      solutionTypes: [
        SolutionType.OffreEmploi,
        if (isCej) SolutionType.Alternance,
        SolutionType.Immersion,
        if (isCej) SolutionType.ServiceCivique,
      ],
    );
  }

  @override
  List<Object?> get props => [solutionTypes];
}
