import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:redux/redux.dart';

class LoginViewModel {
  final bool withLoading;
  final bool withFailure;
  final bool withAlreadyEnteredValues;
  final String firstName;
  final String lastName;
  final Function(String firstName, String lastName) onLoginAction;

  LoginViewModel({
    required this.withLoading,
    required this.withFailure,
    required this.withAlreadyEnteredValues,
    required this.firstName,
    required this.lastName,
    required this.onLoginAction,
  });

  factory LoginViewModel.create(Store<AppState> store) {
    final state = store.state.loginState;
    return LoginViewModel(
      withLoading: state is LoginLoadingState,
      withFailure: state is LoginFailureState,
      withAlreadyEnteredValues: state is LoginLoadingState,
      firstName: _firstName(state),
      lastName: _lastName(state),
      onLoginAction: (String firstName, String lastName) => store.dispatch(RequestLoginAction(firstName, lastName)),
    );
  }
}

String _firstName(LoginState state) {
  if (state is LoginLoadingState) return state.firstName;
  if (state is LoginFailureState) return state.firstName;
  return "";
}

String _lastName(LoginState state) {
  if (state is LoginLoadingState) return state.lastName;
  if (state is LoginFailureState) return state.lastName;
  return "";
}
