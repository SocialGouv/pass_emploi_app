import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:pass_emploi_app/redux/states/chat_status_state.dart';
import 'package:pass_emploi_app/redux/states/create_user_action_state.dart';
import 'package:pass_emploi_app/redux/states/deep_link_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/search_location_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:pass_emploi_app/redux/states/user_action_delete_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_update_state.dart';

import 'offre_emploi_favoris_state.dart';
import 'offre_emploi_favoris_update_state.dart';
import 'offre_emploi_search_results_state.dart';
import 'offre_emploi_search_state.dart';

class AppState extends Equatable {
  final DeepLinkState deepLinkState;
  final CreateUserActionState createUserActionState;
  final UserActionUpdateState userActionUpdateState;
  final UserActionDeleteState userActionDeleteState;
  final ChatStatusState chatStatusState;
  final ChatState chatState;
  final OffreEmploiSearchState offreEmploiSearchState;
  final State<OffreEmploiDetails> offreEmploiDetailsState;
  final OffreEmploiSearchResultsState offreEmploiSearchResultsState;
  final OffreEmploiSearchParametersState offreEmploiSearchParametersState;
  final OffreEmploiFavorisState offreEmploiFavorisState;
  final OffreEmploiFavorisUpdateState offreEmploiFavorisUpdateState;
  final SearchLocationState searchLocationState;
  final State<User> loginState;
  final State<List<UserAction>> userActionState;
  final State<List<Rendezvous>> rendezvousState;
  final State<List<Immersion>> immersionSearchState;
  final State<ImmersionDetails> immersionDetailsState;

  AppState({
    required this.deepLinkState,
    required this.createUserActionState,
    required this.userActionUpdateState,
    required this.userActionDeleteState,
    required this.chatStatusState,
    required this.chatState,
    required this.offreEmploiSearchState,
    required this.offreEmploiDetailsState,
    required this.offreEmploiSearchResultsState,
    required this.offreEmploiSearchParametersState,
    required this.offreEmploiFavorisState,
    required this.offreEmploiFavorisUpdateState,
    required this.searchLocationState,
    required this.loginState,
    required this.userActionState,
    required this.rendezvousState,
    required this.immersionSearchState,
    required this.immersionDetailsState,
  });

  AppState copyWith({
    final CreateUserActionState? createUserActionState,
    final UserActionUpdateState? userActionUpdateState,
    final UserActionDeleteState? userActionDeleteState,
    final ChatStatusState? chatStatusState,
    final ChatState? chatState,
    final OffreEmploiSearchState? offreEmploiSearchState,
    final DeepLinkState? deepLinkState,
    final OffreEmploiSearchResultsState? offreEmploiSearchResultsState,
    final OffreEmploiSearchParametersState? offreEmploiSearchParametersState,
    final OffreEmploiFavorisState? offreEmploiFavorisState,
    final OffreEmploiFavorisUpdateState? offreEmploiFavorisUpdateState,
    final SearchLocationState? searchLocationState,
    final State<User>? loginState,
    final State<List<UserAction>>? userActionState,
    final State<List<Rendezvous>>? rendezvousState,
    final State<OffreEmploiDetails>? offreEmploiDetailsState,
    final State<List<Immersion>>? immersionSearchState,
    final State<ImmersionDetails>? immersionDetailsState,
  }) {
    return AppState(
      deepLinkState: deepLinkState ?? this.deepLinkState,
      createUserActionState: createUserActionState ?? this.createUserActionState,
      userActionUpdateState: userActionUpdateState ?? this.userActionUpdateState,
      userActionDeleteState: userActionDeleteState ?? this.userActionDeleteState,
      chatStatusState: chatStatusState ?? this.chatStatusState,
      chatState: chatState ?? this.chatState,
      offreEmploiSearchState: offreEmploiSearchState ?? this.offreEmploiSearchState,
      offreEmploiDetailsState: offreEmploiDetailsState ?? this.offreEmploiDetailsState,
      offreEmploiSearchResultsState: offreEmploiSearchResultsState ?? this.offreEmploiSearchResultsState,
      offreEmploiSearchParametersState: offreEmploiSearchParametersState ?? this.offreEmploiSearchParametersState,
      offreEmploiFavorisState: offreEmploiFavorisState ?? this.offreEmploiFavorisState,
      offreEmploiFavorisUpdateState: offreEmploiFavorisUpdateState ?? this.offreEmploiFavorisUpdateState,
      searchLocationState: searchLocationState ?? this.searchLocationState,
      loginState: loginState ?? this.loginState,
      userActionState: userActionState ?? this.userActionState,
      rendezvousState: rendezvousState ?? this.rendezvousState,
      immersionSearchState: immersionSearchState ?? this.immersionSearchState,
      immersionDetailsState: immersionDetailsState ?? this.immersionDetailsState,
    );
  }

  factory AppState.initialState() {
    return AppState(
      deepLinkState: DeepLinkState.notInitialized(),
      createUserActionState: CreateUserActionState.notInitialized(),
      userActionUpdateState: UserActionUpdateState.notUpdating(),
      userActionDeleteState: UserActionDeleteState.notInitialized(),
      chatStatusState: ChatStatusState.notInitialized(),
      chatState: ChatState.notInitialized(),
      offreEmploiSearchState: OffreEmploiSearchState.notInitialized(),
      offreEmploiDetailsState: State<OffreEmploiDetails>.notInitialized(),
      offreEmploiSearchResultsState: OffreEmploiSearchResultsState.notInitialized(),
      offreEmploiSearchParametersState: OffreEmploiSearchParametersState.notInitialized(),
      offreEmploiFavorisState: OffreEmploiFavorisState.notInitialized(),
      offreEmploiFavorisUpdateState: OffreEmploiFavorisUpdateState({}),
      searchLocationState: SearchLocationState([]),
      loginState: State<User>.notInitialized(),
      userActionState: State<List<UserAction>>.notInitialized(),
      rendezvousState: State<List<Rendezvous>>.notInitialized(),
      immersionSearchState: State<List<Immersion>>.notInitialized(),
      immersionDetailsState: State<ImmersionDetails>.notInitialized(),
    );
  }

  @override
  List<Object?> get props => [
        deepLinkState,
        createUserActionState,
        userActionUpdateState,
        userActionDeleteState,
        chatStatusState,
        chatState,
        offreEmploiSearchState,
        offreEmploiDetailsState,
        offreEmploiSearchResultsState,
        offreEmploiSearchParametersState,
        offreEmploiFavorisState,
        offreEmploiFavorisUpdateState,
        searchLocationState,
        loginState,
        userActionState,
        rendezvousState,
        immersionSearchState,
        immersionDetailsState,
      ];

  @override
  bool? get stringify => true;
}
