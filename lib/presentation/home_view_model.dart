import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:redux/redux.dart';

class HomeViewModel {
  final String userId;

  HomeViewModel(this.userId);

  factory HomeViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    return HomeViewModel(loginState is LoginCompleted ? loginState.user.id : "LOGIN NOT COMPLETED");
  }
}
