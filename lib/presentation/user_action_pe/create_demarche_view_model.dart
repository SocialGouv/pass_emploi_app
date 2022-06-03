import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/user_action_pe/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/user_action_pe/create/create_demarche_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CreateDemarcheViewModel extends Equatable {
  final bool showError;
  final bool shouldGoBack;
  final Function(String, DateTime) createDemarche;

  CreateDemarcheViewModel({
    required this.showError,
    required this.shouldGoBack,
    required this.createDemarche,
  });

  factory CreateDemarcheViewModel.create(Store<AppState> store) {
    return CreateDemarcheViewModel(
      showError: store.state.createDemarcheState is CreateDemarcheFailureState,
      shouldGoBack: store.state.createDemarcheState is CreateDemarcheSuccessState,
      createDemarche: (commentaire, echeanceDate) => store.dispatch(CreateDemarcheRequestAction(commentaire, echeanceDate)),
    );
  }

  @override
  List<Object> get props => [shouldGoBack, showError];
}
