import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:redux/redux.dart';

// TODO-115 : test
class LoginViewModelV2 extends Equatable {
  final bool withLoading;
  final bool withFailure;
  final Function() onLoginAction;

  LoginViewModelV2({
    required this.withLoading,
    required this.withFailure,
    required this.onLoginAction,
  });

  factory LoginViewModelV2.create(Store<AppState> store) {
    final state = store.state.loginState;
    return LoginViewModelV2(
      withLoading: state is LoginLoadingState,
      withFailure: state is LoginFailureState,
      onLoginAction: () => store.dispatch(RequestLoginActionV2()),
    );
  }

  @override
  List<Object?> get props => [withLoading, withFailure];
}
