import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CreateDemarcheStep1ViewModel extends Equatable {
  final Function(String) onSearchDemarche;

  CreateDemarcheStep1ViewModel({
    required this.onSearchDemarche,
  });

  factory CreateDemarcheStep1ViewModel.create(Store<AppState> store) {
    return CreateDemarcheStep1ViewModel(
      onSearchDemarche: (query) => store.dispatch(SearchDemarcheRequestAction(query)),
    );
  }

  @override
  List<Object?> get props => [];
}
