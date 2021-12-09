import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:pass_emploi_app/redux/states/chat_status_state.dart';
import 'package:pass_emploi_app/redux/states/create_user_action_state.dart';
import 'package:pass_emploi_app/redux/states/deep_link_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/rendezvous_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_delete_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_update_state.dart';

import 'login_state.dart';
import 'offre_emploi_favoris_state.dart';
import 'offre_emploi_favoris_update_state.dart';
import 'offre_emploi_search_results_state.dart';
import 'offre_emploi_search_state.dart';

class AppState extends Equatable {
  final DeepLinkState deepLinkState;
  final LoginState loginState;
  final UserActionState userActionState;
  final CreateUserActionState createUserActionState;
  final UserActionUpdateState userActionUpdateState;
  final UserActionDeleteState userActionDeleteState;
  final RendezvousState rendezvousState;
  final ChatStatusState chatStatusState;
  final ChatState chatState;
  final OffreEmploiSearchState offreEmploiSearchState;
  final OffreEmploiDetailsState offreEmploiDetailsState;
  final OffreEmploiSearchResultsState offreEmploiSearchResultsState;
  final OffreEmploiSearchParametersState offreEmploiSearchParametersState;
  final OffreEmploiFavorisState offreEmploiFavorisState;
  final OffreEmploiFavorisUpdateState offreEmploiFavorisUpdateState;

  AppState({
    required this.deepLinkState,
    required this.loginState,
    required this.userActionState,
    required this.createUserActionState,
    required this.userActionUpdateState,
    required this.userActionDeleteState,
    required this.rendezvousState,
    required this.chatStatusState,
    required this.chatState,
    required this.offreEmploiSearchState,
    required this.offreEmploiDetailsState,
    required this.offreEmploiSearchResultsState,
    required this.offreEmploiSearchParametersState,
    required this.offreEmploiFavorisState,
    required this.offreEmploiFavorisUpdateState,
  });

  AppState copyWith({
    final LoginState? loginState,
    final UserActionState? userActionState,
    final CreateUserActionState? createUserActionState,
    final UserActionUpdateState? userActionUpdateState,
    final UserActionDeleteState? userActionDeleteState,
    final RendezvousState? rendezvousState,
    final ChatStatusState? chatStatusState,
    final ChatState? chatState,
    final OffreEmploiSearchState? offreEmploiSearchState,
    final OffreEmploiDetailsState? offreEmploiDetailsState,
    final DeepLinkState? deepLinkState,
    final OffreEmploiSearchResultsState? offreEmploiSearchResultsState,
    final OffreEmploiSearchParametersState? offreEmploiSearchParametersState,
    final OffreEmploiFavorisState? offreEmploiFavorisState,
    final OffreEmploiFavorisUpdateState? offreEmploiFavorisUpdateState,
  }) {
    return AppState(
      deepLinkState: deepLinkState ?? this.deepLinkState,
      loginState: loginState ?? this.loginState,
      userActionState: userActionState ?? this.userActionState,
      createUserActionState: createUserActionState ?? this.createUserActionState,
      userActionUpdateState: userActionUpdateState ?? this.userActionUpdateState,
      userActionDeleteState: userActionDeleteState ?? this.userActionDeleteState,
      rendezvousState: rendezvousState ?? this.rendezvousState,
      chatStatusState: chatStatusState ?? this.chatStatusState,
      chatState: chatState ?? this.chatState,
      offreEmploiSearchState: offreEmploiSearchState ?? this.offreEmploiSearchState,
      offreEmploiDetailsState: offreEmploiDetailsState ?? this.offreEmploiDetailsState,
      offreEmploiSearchResultsState: offreEmploiSearchResultsState ?? this.offreEmploiSearchResultsState,
      offreEmploiSearchParametersState: offreEmploiSearchParametersState ?? this.offreEmploiSearchParametersState,
      offreEmploiFavorisState: offreEmploiFavorisState ?? this.offreEmploiFavorisState,
      offreEmploiFavorisUpdateState: offreEmploiFavorisUpdateState ?? this.offreEmploiFavorisUpdateState,
    );
  }

  factory AppState.initialState() {
    return AppState(
      deepLinkState: DeepLinkState.notInitialized(),
      loginState: LoginState.notInitialized(),
      userActionState: UserActionState.notInitialized(),
      createUserActionState: CreateUserActionState.notInitialized(),
      userActionUpdateState: UserActionUpdateState.notUpdating(),
      userActionDeleteState: UserActionDeleteState.notInitialized(),
      rendezvousState: RendezvousState.notInitialized(),
      chatStatusState: ChatStatusState.notInitialized(),
      chatState: ChatState.notInitialized(),
      offreEmploiSearchState: OffreEmploiSearchState.notInitialized(),
      offreEmploiDetailsState: OffreEmploiDetailsState.notInitialized(),
      offreEmploiSearchResultsState: OffreEmploiSearchResultsState.notInitialized(),
      offreEmploiSearchParametersState: OffreEmploiSearchParametersState.notInitialized(),
      offreEmploiFavorisState: OffreEmploiFavorisState.notInitialized(),
      offreEmploiFavorisUpdateState: OffreEmploiFavorisUpdateState({}),
    );
  }

  @override
  List<Object?> get props =>
      [
        deepLinkState,
        loginState,
        userActionState,
        createUserActionState,
        userActionUpdateState,
        userActionDeleteState,
        rendezvousState,
        chatStatusState,
        chatState,
        offreEmploiSearchState,
        offreEmploiDetailsState,
        offreEmploiSearchResultsState,
        offreEmploiSearchParametersState,
        offreEmploiFavorisState,
        offreEmploiFavorisUpdateState,
      ];

  @override
  bool? get stringify => true;
}
