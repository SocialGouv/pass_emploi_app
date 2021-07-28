import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:redux/redux.dart';

class HomeViewModel {
  final bool withLoading;

  HomeViewModel(this.withLoading);

  factory HomeViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    return HomeViewModel(loginState is LoginCompleted ? false : true);
  }
}
