import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class LoginViewModel extends Equatable {
  final DisplayState displayState;
  final List<LoginButtonViewModel> loginButtons;

  LoginViewModel({
    required this.displayState,
    required this.loginButtons,
  });

  factory LoginViewModel.create(Flavor flavor, Store<AppState> store) {
    final state = store.state.loginState;
    return LoginViewModel(
      displayState: state is UserNotLoggedInState ? DisplayState.CONTENT : displayStateFromState(state),
      loginButtons: _loginButtons(store, flavor),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

List<LoginButtonViewModel> _loginButtons(Store<AppState> store, Flavor flavor) {
  return [
    LoginButtonViewModel(
      label: Strings.loginMissionLocale,
      action: () => store.dispatch(RequestLoginAction(RequestLoginMode.SIMILO)),
    ),
    LoginButtonViewModel(
      label: Strings.loginPoleEmploi,
      action: () => store.dispatch(RequestLoginAction(RequestLoginMode.POLE_EMPLOI)),
    ),
    if (flavor == Flavor.STAGING)
      LoginButtonViewModel(
        label: Strings.loginGeneric,
        action: () => store.dispatch(RequestLoginAction(RequestLoginMode.GENERIC)),
      ),
  ];
}

class LoginButtonViewModel extends Equatable {
  final String label;
  final Function() action;

  LoginButtonViewModel({required this.label, required this.action});

  @override
  List<Object?> get props => [label];
}
