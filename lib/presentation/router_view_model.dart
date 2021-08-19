import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:redux/redux.dart';

class RouterViewModel {
  final bool withSplashScreen;
  final bool withLoginPage;
  final bool withHomePage;

  RouterViewModel({required this.withSplashScreen, required this.withLoginPage, required this.withHomePage});

  factory RouterViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    var withSplashScreen = loginState is LoginNotInitializedState;
    return RouterViewModel(
      withSplashScreen: withSplashScreen,
      withLoginPage: !withSplashScreen && !(loginState is LoggedInState),
      withHomePage: loginState is LoggedInState,
    );
  }
}
