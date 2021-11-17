import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:redux/redux.dart';

class OffreEmploiSearchResultsViewModel {
  final List<OffreEmploiItemViewModel> items;
  final Function() onReachBottom;

  OffreEmploiSearchResultsViewModel({required this.items, required this.onReachBottom});

  factory OffreEmploiSearchResultsViewModel.create(Store<AppState> store) {
    return OffreEmploiSearchResultsViewModel(
      items: _items(store.state.offreEmploiSearchState),
      onReachBottom: () => _reachBottom(),
    );
  }
}

void _reachBottom() {}

List<OffreEmploiItemViewModel> _items(OffreEmploiSearchState searchState) {
  return searchState is OffreEmploiSearchSuccessState
      ? searchState.offres
          .map((e) => OffreEmploiItemViewModel(
                e.id,
                e.title,
                e.companyName,
                e.contractType,
                e.duration,
                e.location,
              ))
          .toList()
      : [];
}

class OffreEmploiItemViewModel extends Equatable {
  final String id;
  final String title;
  final String? companyName;
  final String contractType;
  final String? duration;
  final String? location;

  OffreEmploiItemViewModel(this.id, this.title, this.companyName, this.contractType, this.duration, this.location);

  @override
  List<Object?> get props => [
        id,
        title,
        companyName,
        contractType,
        location,
        duration,
      ];
}
