import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/rendezvous_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/home_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

import 'home_item.dart';

class HomePageViewModel {
  final String userId;
  final String title;
  final bool withLoading;
  final bool withFailure;
  final List<HomeItem> items;
  final Function() onRetry;
  final Function() onLogout;

  HomePageViewModel({
    required this.userId,
    required this.title,
    required this.withLoading,
    required this.withFailure,
    required this.items,
    required this.onRetry,
    required this.onLogout,
  });

  factory HomePageViewModel.create(Store<AppState> store) {
    if (!(store.state.loginState is LoggedInState)) {
      throw Exception("User should be logged in to access home page");
    }
    final user = (store.state.loginState as LoggedInState).user;
    final homeState = store.state.homeState;
    final home = homeState is HomeSuccessState ? homeState.home : null;
    final List<UserAction> actions = home != null ? home.actions : [];
    final List<Rendezvous> rendezvous = home != null ? home.rendezvous : [];
    final doneActionsCount = home != null ? home.doneActionsCount : 0;
    return HomePageViewModel(
      userId: user.id,
      title: Strings.hello(user.firstName),
      withLoading: homeState is HomeLoadingState || homeState is HomeNotInitializedState,
      withFailure: homeState is HomeFailureState,
      items: [..._actionItems(actions, doneActionsCount), ..._rendezvousItems(rendezvous)],
      onRetry: () => store.dispatch(RequestHomeAction(user.id)),
      onLogout: () => store.dispatch(LogoutAction()),
    );
  }
}

_actionItems(List<UserAction> actions, int doneActionsCount) {
  return (<HomeItem?>[]
        ..add(HomeItem.section(Strings.myActions))
        ..add(actions.isEmpty && doneActionsCount == 0 ? HomeItem.message(Strings.noActionsYetContactConseiller) : null)
        ..add(actions.isEmpty && doneActionsCount > 0 ? HomeItem.message(Strings.noMoreActionsContactConseiller) : null)
        ..addAll(actions.map((action) => HomeItem.action(UserActionViewModel.create(action))))
        ..add(actions.isNotEmpty || doneActionsCount > 0 ? HomeItem.allActionsButton() : null))
      .whereType<HomeItem>()
      .toList();
}

_rendezvousItems(List<Rendezvous> rendezvous) {
  return (<HomeItem?>[]
        ..add(HomeItem.section(Strings.upcomingRendezVous))
        ..add(rendezvous.isEmpty ? HomeItem.message(Strings.noUpcomingRendezVous) : null)
        ..addAll(rendezvous.map((rdv) => HomeItem.rendezvous(RendezvousViewModel.create(rdv)))))
      .whereType<HomeItem>()
      .toList();
}
