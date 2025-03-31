import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CreateDemarcheSuccessViewModel extends Equatable {
  final String demarcheId;

  CreateDemarcheSuccessViewModel({
    required this.demarcheId,
  });

  factory CreateDemarcheSuccessViewModel.create(Store<AppState> store) {
    return CreateDemarcheSuccessViewModel(
      demarcheId: _demarcheId(store),
    );
  }

  @override
  List<Object?> get props => [demarcheId];
}

String _demarcheId(Store<AppState> store) {
  final createState = store.state.createDemarcheState;
  return createState is CreateDemarcheSuccessState ? createState.demarcheCreatedId : "";
}
