import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_id_state.dart';
import 'package:redux/redux.dart';

class FavoriHeartViewModel extends Equatable {
  final bool isFavori;
  final bool withError;

  FavoriHeartViewModel._({required this.isFavori, required this.withError});

  factory FavoriHeartViewModel.create(String offreId, Store<AppState> store) {
    return FavoriHeartViewModel._(
      isFavori: _isFavori(offreId, store.state.offreEmploiFavorisState),
      withError: false,
    );
  }

  @override
  List<Object?> get props => [isFavori, withError];
}

bool _isFavori(String offreId, OffreEmploiFavorisIdState offreEmploiFavorisState) {
  if (offreEmploiFavorisState is OffreEmploiFavorisIdLoadedState) {
    return offreEmploiFavorisState.offreEmploiFavorisListId.contains(offreId);
  } else {
    return false;
  }
}
