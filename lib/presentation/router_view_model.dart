import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:redux/redux.dart';

class RouterViewModel extends Equatable {
  final bool withSplashScreen;
  final bool withLoginPage;
  final bool withMainPage;
  final String userId;

  RouterViewModel({
    required this.withSplashScreen,
    required this.withLoginPage,
    required this.withMainPage,
    required this.userId,
  });

  factory RouterViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    final withSplashScreen = loginState is LoginNotInitializedState;
    return RouterViewModel(
      withSplashScreen: withSplashScreen,
      withLoginPage: !withSplashScreen && !(loginState is LoggedInState),
      withMainPage: loginState is LoggedInState,
      userId: loginState is LoggedInState ? loginState.user.id : "",
    );
  }

  @override
  List<Object?> get props => [withSplashScreen, withLoginPage, withMainPage, userId];
}
