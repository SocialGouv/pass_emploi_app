import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

extension StoreDeeplinks on Store<AppState> {
  bool shouldHandleDeeplink<T>() {
    final deeplinkState = state.deepLinkState;
    if (deeplinkState is HandleDeepLinkState) {
      return deeplinkState.deepLink is T;
    }
    return false;
  }

  DeepLink? getDeepLink() {
    final deeplinkState = state.deepLinkState;
    return deeplinkState is HandleDeepLinkState ? deeplinkState.deepLink : null;
  }

  T? getDeepLinkAs<T>() {
    final deeplinkState = state.deepLinkState;
    if (deeplinkState is HandleDeepLinkState) {
      if (deeplinkState.deepLink is T) {
        return deeplinkState.deepLink as T;
      }
    }
    return null;
  }
}
