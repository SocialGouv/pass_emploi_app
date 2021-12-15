import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/presentation/login_view_model.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:redux/redux.dart';

import '../doubles/spies.dart';

void main() {
  test('View model displays LOADER when login state is loading', () {
    final state = AppState.initialState().copyWith(loginState: LoginLoadingState());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = LoginViewModel.create(store);

    expect(viewModel.displayState, LoginViewModelDisplayState.LOADER);
  });

  test('View model displays FAILURE when login state is failure', () {
    final state = AppState.initialState().copyWith(loginState: LoginFailureState());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = LoginViewModel.create(store);

    expect(viewModel.displayState, LoginViewModelDisplayState.FAILURE);
  });

  test('View model displays CONTENT when login state is logged in', () {
    final state = AppState.initialState().copyWith(
      loginState: LoginState.loggedIn(User(id: "i", firstName: "F", lastName: "L")),
    );
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = LoginViewModel.create(store);

    expect(viewModel.displayState, LoginViewModelDisplayState.CONTENT);
  });

  test('View model triggers RequestLoginAction with GENERIC mode when generic login is performed', () {
    final store = StoreSpy();
    final viewModel = LoginViewModel.create(store);

    viewModel.onGenericLoginAction();

    expect(store.dispatchedAction, isA<RequestLoginAction>());
    expect((store.dispatchedAction as RequestLoginAction).mode, RequestLoginMode.GENERIC);
  });

  test('View model triggers RequestLoginAction with SIMILO mode when generic login is performed', () {
    final store = StoreSpy();
    final viewModel = LoginViewModel.create(store);

    viewModel.onSimiloLoginAction();

    expect(store.dispatchedAction, isA<RequestLoginAction>());
    expect((store.dispatchedAction as RequestLoginAction).mode, RequestLoginMode.SIMILO);
  });
}
