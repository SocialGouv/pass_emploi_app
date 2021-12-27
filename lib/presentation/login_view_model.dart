import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:redux/redux.dart';

enum LoginViewModelDisplayState { CONTENT, LOADER, FAILURE }

class LoginViewModel extends Equatable {
  final LoginViewModelDisplayState displayState;
  final Function() onGenericLoginAction;
  final Function() onSimiloLoginAction;

  LoginViewModel({required this.displayState, required this.onGenericLoginAction, required this.onSimiloLoginAction});

  factory LoginViewModel.create(Store<AppState> store) {
    final state = store.state.loginState;
    return LoginViewModel(
      displayState: _displayState(state),
      onGenericLoginAction: () => store.dispatch(RequestLoginAction(RequestLoginMode.GENERIC)),
      onSimiloLoginAction: () => store.dispatch(RequestLoginAction(RequestLoginMode.SIMILO)),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

LoginViewModelDisplayState _displayState(State<User> state) {
  if (state.isLoading()) return LoginViewModelDisplayState.LOADER;
  if (state.isFailure()) return LoginViewModelDisplayState.FAILURE;
  return LoginViewModelDisplayState.CONTENT;
}
