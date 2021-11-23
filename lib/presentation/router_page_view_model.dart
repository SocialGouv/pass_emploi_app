import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/presentation/main_page_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/deep_link_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:redux/redux.dart';

enum RouterPageDisplayState { SPLASH, LOGIN, MAIN }

class RouterPageViewModel extends Equatable {
  final String userId;
  final RouterPageDisplayState routerPageDisplayState;
  final MainPageDisplayState mainPageDisplayState;
  final int deepLinkKey;

  RouterPageViewModel({
    required this.userId,
    required this.routerPageDisplayState,
    required this.mainPageDisplayState,
    required this.deepLinkKey,
  });

  factory RouterPageViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    return RouterPageViewModel(
      userId: loginState is LoggedInState ? loginState.user.id : "",
      routerPageDisplayState: _routerPageDisplayState(store),
      mainPageDisplayState: _toMainPageDisplayState(store.state.deepLinkState),
      deepLinkKey: store.state.deepLinkState.deepLinkOpenedAt.hashCode,
    );
  }

  @override
  List<Object?> get props => [userId, mainPageDisplayState, routerPageDisplayState, deepLinkKey];
}

RouterPageDisplayState _routerPageDisplayState(Store<AppState> store) {
  final loginState = store.state.loginState;
  if (loginState is LoginNotInitializedState) return RouterPageDisplayState.SPLASH;
  if (loginState is LoggedInState) return RouterPageDisplayState.MAIN;
  return RouterPageDisplayState.LOGIN;
}

MainPageDisplayState _toMainPageDisplayState(DeepLinkState deepLinkState) {
  switch (deepLinkState.deepLink) {
    case DeepLink.ROUTE_TO_RENDEZVOUS:
      return MainPageDisplayState.RENDEZVOUS_LIST;
    case DeepLink.ROUTE_TO_CHAT:
      return MainPageDisplayState.CHAT;
    case DeepLink.ROUTE_TO_ACTION:
      return MainPageDisplayState.ACTIONS_LIST;
    case DeepLink.NOT_SET:
      return MainPageDisplayState.DEFAULT;
  }
}
