import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:redux/redux.dart';

class LoginViewModel extends Equatable {
  final DisplayState displayState;
  final Function() onGenericLoginAction;
  final Function() onSimiloLoginAction;

  LoginViewModel({required this.displayState, required this.onGenericLoginAction, required this.onSimiloLoginAction});

  factory LoginViewModel.create(Store<AppState> store) {
    final state = store.state.loginState;
    return LoginViewModel(
      displayState: state is UserNotLoggedInState ? DisplayState.CONTENT : displayStateFromState(state),
      onGenericLoginAction: () => store.dispatch(RequestLoginAction(RequestLoginMode.GENERIC)),
      onSimiloLoginAction: () => store.dispatch(RequestLoginAction(RequestLoginMode.SIMILO)),
    );
  }

  @override
  List<Object?> get props => [displayState];
}
