import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class ChoixOrganismeExplainationViewModel extends Equatable {
  final String explainationText;
  final Function() loginAction;

  ChoixOrganismeExplainationViewModel({required this.explainationText, required this.loginAction});

  factory ChoixOrganismeExplainationViewModel.create(Store<AppState> store, {required bool isPoleEmploi}) {
    return ChoixOrganismeExplainationViewModel(
      explainationText: isPoleEmploi ? Strings.rendezVousPoleEmploi : Strings.rendezVousMissionLocale,
      loginAction: () => store.dispatch(RequestLoginAction(
        isPoleEmploi ? RequestLoginMode.POLE_EMPLOI : RequestLoginMode.SIMILO,
      )),
    );
  }

  @override
  List<Object?> get props => [explainationText];
}
