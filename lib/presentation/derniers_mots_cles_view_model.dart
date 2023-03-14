import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DerniersMotsClesViewModel {
  final List<String> derniersMotsCles;

  DerniersMotsClesViewModel({required this.derniersMotsCles});

  factory DerniersMotsClesViewModel.create(Store<AppState> store) {
    final motsCles = store.state.recherchesDerniersMotsClesState.motsCles;
    return DerniersMotsClesViewModel(derniersMotsCles: motsCles);
  }
}
