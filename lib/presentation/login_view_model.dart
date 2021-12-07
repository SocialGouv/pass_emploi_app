import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:redux/redux.dart';

enum LoginViewModelDisplayState { CONTENT, LOADER, FAILURE }

class LoginViewModel extends Equatable {
  final LoginViewModelDisplayState displayState;
  final Function() onLoginAction;

  LoginViewModel({required this.displayState, required this.onLoginAction});

  factory LoginViewModel.create(Store<AppState> store) {
    final state = store.state.loginState;
    return LoginViewModel(
      displayState: _displayState(state),
      onLoginAction: () => store.dispatch(RequestLoginAction()),
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
