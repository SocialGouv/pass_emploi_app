import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:redux/redux.dart';

class LoginViewModel {
  final bool loggedIn;
  final bool withLoading;
  final bool withFailure;
  final bool withAlreadyEnteredValues;
  final String accessCode;
  final Function(String accessCode) onLoginAction;

  LoginViewModel({
    required this.loggedIn,
    required this.withLoading,
    required this.withFailure,
    required this.withAlreadyEnteredValues,
    required this.accessCode,
    required this.onLoginAction,
  });

  factory LoginViewModel.create(Store<AppState> store) {
    final state = store.state.loginState;
    return LoginViewModel(
      loggedIn: state is LoggedInState,
      withLoading: state is LoginLoadingState,
      withFailure: state is LoginFailureState,
      withAlreadyEnteredValues: state is LoginLoadingState,
      accessCode: _accessCode(state),
      onLoginAction: (String accessCode) => store.dispatch(RequestLoginAction(accessCode)),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginViewModel &&
          runtimeType == other.runtimeType &&
          loggedIn == other.loggedIn &&
          withLoading == other.withLoading &&
          withFailure == other.withFailure &&
          withAlreadyEnteredValues == other.withAlreadyEnteredValues &&
          accessCode == other.accessCode;

  @override
  int get hashCode =>
      loggedIn.hashCode ^
      withLoading.hashCode ^
      withFailure.hashCode ^
      withAlreadyEnteredValues.hashCode ^
      accessCode.hashCode;
}

String _accessCode(LoginState state) {
  if (state is LoginLoadingState) return state.accessCode;
  if (state is LoginFailureState) return state.accessCode;
  if (state is LoggedInState) return state.user.id;
  return "";
}
