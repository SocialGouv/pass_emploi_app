import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:redux/redux.dart';

class RouterViewModel {
  final bool withLoginPage;
  final bool withHomePage;

  RouterViewModel({required this.withLoginPage, required this.withHomePage});

  factory RouterViewModel.create(Store<AppState> store) {
    final userIsLoggedIn = store.state.loginState is LoggedInState;
    return RouterViewModel(
      withLoginPage: !userIsLoggedIn,
      withHomePage: userIsLoggedIn,
    );
  }
}
