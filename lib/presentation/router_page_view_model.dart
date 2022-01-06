import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/presentation/main_page_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/deep_link_state.dart';
import 'package:redux/redux.dart';

enum RouterPageDisplayState { SPLASH, LOGIN, MAIN }

class RouterPageViewModel extends Equatable {
  final RouterPageDisplayState routerPageDisplayState;
  final MainPageDisplayState mainPageDisplayState;
  final int deepLinkKey;

  RouterPageViewModel({
    required this.routerPageDisplayState,
    required this.mainPageDisplayState,
    required this.deepLinkKey,
  });

  factory RouterPageViewModel.create(Store<AppState> store) {
    return RouterPageViewModel(
      routerPageDisplayState: _routerPageDisplayState(store),
      mainPageDisplayState: _toMainPageDisplayState(store.state.deepLinkState),
      deepLinkKey: store.state.deepLinkState.deepLinkOpenedAt.hashCode,
    );
  }

  @override
  List<Object?> get props => [mainPageDisplayState, routerPageDisplayState, deepLinkKey];
}

RouterPageDisplayState _routerPageDisplayState(Store<AppState> store) {
  final loginState = store.state.loginState;
  if (loginState.isNotInitialized()) return RouterPageDisplayState.SPLASH;
  if (loginState.isSuccess()) return RouterPageDisplayState.MAIN;
  return RouterPageDisplayState.LOGIN;
}

MainPageDisplayState _toMainPageDisplayState(DeepLinkState deepLinkState) {
  switch (deepLinkState.deepLink) {
    case DeepLink.ROUTE_TO_RENDEZVOUS:
      return MainPageDisplayState.RENDEZVOUS_TAB;
    case DeepLink.ROUTE_TO_CHAT:
      return MainPageDisplayState.CHAT;
    case DeepLink.ROUTE_TO_ACTION:
      return MainPageDisplayState.ACTIONS_TAB;
    case DeepLink.NOT_SET:
      return MainPageDisplayState.DEFAULT;
  }
}
