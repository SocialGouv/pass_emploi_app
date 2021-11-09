import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:pass_emploi_app/redux/states/chat_status_state.dart';
import 'package:pass_emploi_app/redux/states/create_user_action_state.dart';
import 'package:pass_emploi_app/redux/states/home_state.dart';
import 'package:pass_emploi_app/redux/states/rendezvous_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_update_state.dart';

import 'login_state.dart';
import 'offre_emploi_search_state.dart';

class AppState extends Equatable {
  final LoginState loginState;
  final HomeState homeState;
  final UserActionState userActionState;
  final CreateUserActionState createUserActionState;
  final UserActionUpdateState userActionUpdateState;
  final RendezvousState rendezvousState;
  final ChatStatusState chatStatusState;
  final ChatState chatState;
  final OffreEmploiSearchState offreEmploiSearchState;

  AppState({
    required this.loginState,
    required this.homeState,
    required this.userActionState,
    required this.createUserActionState,
    required this.userActionUpdateState,
    required this.rendezvousState,
    required this.chatStatusState,
    required this.chatState,
    required this.offreEmploiSearchState,
  });

  AppState copyWith({
    final LoginState? loginState,
    final HomeState? homeState,
    final UserActionState? userActionState,
    final CreateUserActionState? createUserActionState,
    final UserActionUpdateState? userActionUpdateState,
    final RendezvousState? rendezvousState,
    final ChatStatusState? chatStatusState,
    final ChatState? chatState,
    final OffreEmploiSearchState? offreEmploiSearchState,
  }) {
    return AppState(
      loginState: loginState ?? this.loginState,
      homeState: homeState ?? this.homeState,
      userActionState: userActionState ?? this.userActionState,
      createUserActionState: createUserActionState ?? this.createUserActionState,
      userActionUpdateState: userActionUpdateState ?? this.userActionUpdateState,
      rendezvousState: rendezvousState ?? this.rendezvousState,
      chatStatusState: chatStatusState ?? this.chatStatusState,
      chatState: chatState ?? this.chatState,
      offreEmploiSearchState: offreEmploiSearchState ?? this.offreEmploiSearchState,
    );
  }

  factory AppState.initialState() {
    return AppState(
      loginState: LoginState.notInitialized(),
      homeState: HomeState.notInitialized(),
      userActionState: UserActionState.notInitialized(),
      createUserActionState: CreateUserActionState.notInitialized(),
      userActionUpdateState: UserActionUpdateState.notUpdating(),
      rendezvousState: RendezvousState.notInitialized(),
      chatStatusState: ChatStatusState.notInitialized(),
      chatState: ChatState.notInitialized(),
      offreEmploiSearchState: OffreEmploiSearchState.notInitialized(),
    );
  }

  @override
  List<Object?> get props => [
        loginState,
        homeState,
        userActionState,
        userActionUpdateState,
        createUserActionState,
        rendezvousState,
        chatStatusState,
        chatState,
      ];

  @override
  bool? get stringify => true;
}
