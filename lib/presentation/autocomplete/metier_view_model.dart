import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/metier/search_metier_actions.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class MetierViewModel extends Equatable {
  final List<Metier> metiers;
  final Function(String? input) onInputMetier;

  MetierViewModel._({
    required this.metiers,
    required this.onInputMetier,
  });

  factory MetierViewModel.create(Store<AppState> store) {
    return MetierViewModel._(
      metiers: store.state.searchMetierState.metiers,
      onInputMetier: (input) {
        return store.dispatch(SearchMetierRequestAction(input));
      },
    );
  }

  @override
  List<Object?> get props => [metiers];
}
