import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ResultatRechercheViewModel extends Equatable {
  final List<OffreEmploiItemViewModel>? items;

  ResultatRechercheViewModel(this.items);

  factory ResultatRechercheViewModel.create(Store<AppState> store) {
    final results = store.state.rechercheEmploiState.results;
    if (results == null) return ResultatRechercheViewModel(null);
    return ResultatRechercheViewModel(results.map((offre) => OffreEmploiItemViewModel.create(offre)).toList());
  }

  @override
  List<Object?> get props => [items];
}
