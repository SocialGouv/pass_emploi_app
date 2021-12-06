import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:redux/redux.dart';

enum LoginViewModelDisplayState { CONTENT, LOADER, FAILURE }

// TODO-115 : test
class LoginViewModelV2 extends Equatable {
  final LoginViewModelDisplayState displayState;
  final Function() onLoginAction;

  LoginViewModelV2({
    required this.displayState,
    required this.onLoginAction,
  });

  factory LoginViewModelV2.create(Store<AppState> store) {
    final state = store.state.loginState;
    return LoginViewModelV2(
      displayState: _displayState(state),
      onLoginAction: () => store.dispatch(RequestLoginActionV2()),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

LoginViewModelDisplayState _displayState(LoginState state) {
  if (state is LoginLoadingState) return LoginViewModelDisplayState.LOADER;
  if (state is LoginFailureState) return LoginViewModelDisplayState.FAILURE;
  return LoginViewModelDisplayState.CONTENT;
}
