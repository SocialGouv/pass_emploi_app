import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/features/saved_search/delete/saved_search_delete_state.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_state.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/states/configuration_state.dart';
import 'package:pass_emploi_app/redux/states/deep_link_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/saved_search_state.dart';
import 'package:pass_emploi_app/redux/states/search_location_state.dart';
import 'package:pass_emploi_app/redux/states/search_metier_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

import '../../models/saved_search/saved_search.dart';
import 'favoris_state.dart';
import 'immersion_search_request_state.dart';
import 'offre_emploi_favoris_update_state.dart';
import 'offre_emploi_search_results_state.dart';
import 'offre_emploi_search_state.dart';

class AppState extends Equatable {
  final LoginState loginState;
  final DeepLinkState deepLinkState;
  final UserActionListState userActionListState;
  final UserActionCreateState userActionCreateState;
  final UserActionUpdateState userActionUpdateState;
  final UserActionDeleteState userActionDeleteState;
  final ChatStatusState chatStatusState;
  final ChatState chatState;
  final OffreEmploiSearchState offreEmploiSearchState;
  final State<OffreEmploiDetails> offreEmploiDetailsState;
  final OffreEmploiSearchResultsState offreEmploiSearchResultsState;
  final OffreEmploiSearchParametersState offreEmploiSearchParametersState;
  final FavorisState<OffreEmploi> offreEmploiFavorisState;
  final FavorisState<Immersion> immersionFavorisState;
  final FavorisUpdateState favorisUpdateState;
  final SearchLocationState searchLocationState;
  final SearchMetierState searchMetierState;
  final RendezvousState rendezvousState;
  final State<List<Immersion>> immersionSearchState;
  final State<ImmersionDetails> immersionDetailsState;
  final SavedSearchState<OffreEmploiSavedSearch> offreEmploiSavedSearchState;
  final SavedSearchState<ImmersionSavedSearch> immersionSavedSearchState;
  final ConfigurationState configurationState;
  final ImmersionSearchRequestState immersionSearchRequestState;
  final State<List<SavedSearch>> savedSearchesState;
  final SavedSearchDeleteState savedSearchDeleteState;
  final ServiceCiviqueSearchResultState serviceCiviqueSearchResultState;
  final ServiceCiviqueDetailState serviceCiviqueDetailState;

  AppState({
    required this.loginState,
    required this.deepLinkState,
    required this.userActionListState,
    required this.userActionCreateState,
    required this.userActionUpdateState,
    required this.userActionDeleteState,
    required this.chatStatusState,
    required this.chatState,
    required this.offreEmploiSearchState,
    required this.offreEmploiDetailsState,
    required this.offreEmploiSearchResultsState,
    required this.offreEmploiSearchParametersState,
    required this.offreEmploiFavorisState,
    required this.immersionFavorisState,
    required this.favorisUpdateState,
    required this.searchLocationState,
    required this.searchMetierState,
    required this.rendezvousState,
    required this.immersionSearchState,
    required this.immersionDetailsState,
    required this.offreEmploiSavedSearchState,
    required this.immersionSavedSearchState,
    required this.configurationState,
    required this.immersionSearchRequestState,
    required this.savedSearchesState,
    required this.savedSearchDeleteState,
    required this.serviceCiviqueSearchResultState,
    required this.serviceCiviqueDetailState,
  });

  AppState copyWith({
    final LoginState? loginState,
    final UserActionListState? userActionListState,
    final UserActionCreateState? userActionCreateState,
    final UserActionUpdateState? userActionUpdateState,
    final UserActionDeleteState? userActionDeleteState,
    final ChatStatusState? chatStatusState,
    final ChatState? chatState,
    final OffreEmploiSearchState? offreEmploiSearchState,
    final DeepLinkState? deepLinkState,
    final OffreEmploiSearchResultsState? offreEmploiSearchResultsState,
    final OffreEmploiSearchParametersState? offreEmploiSearchParametersState,
    final FavorisState<OffreEmploi>? offreEmploiFavorisState,
    final FavorisState<Immersion>? immersionFavorisState,
    final FavorisUpdateState? favorisUpdateState,
    final SearchLocationState? searchLocationState,
    final SearchMetierState? searchMetierState,
    final RendezvousState? rendezvousState,
    final State<OffreEmploiDetails>? offreEmploiDetailsState,
    final State<List<Immersion>>? immersionSearchState,
    final State<ImmersionDetails>? immersionDetailsState,
    final SavedSearchState<OffreEmploiSavedSearch>? offreEmploiSavedSearchState,
    final SavedSearchState<ImmersionSavedSearch>? immersionSavedSearchState,
    final ConfigurationState? configurationState,
    final ImmersionSearchRequestState? immersionSearchRequestState,
    final State<List<SavedSearch>>? savedSearchesState,
    final SavedSearchDeleteState? savedSearchDeleteState,
    final ServiceCiviqueSearchResultState? serviceCiviqueSearchResultState,
    final ServiceCiviqueDetailState? serviceCiviqueDetailState,
  }) {
    return AppState(
      loginState: loginState ?? this.loginState,
      deepLinkState: deepLinkState ?? this.deepLinkState,
      userActionListState: userActionListState ?? this.userActionListState,
      userActionCreateState: userActionCreateState ?? this.userActionCreateState,
      userActionUpdateState: userActionUpdateState ?? this.userActionUpdateState,
      userActionDeleteState: userActionDeleteState ?? this.userActionDeleteState,
      chatStatusState: chatStatusState ?? this.chatStatusState,
      chatState: chatState ?? this.chatState,
      offreEmploiSearchState: offreEmploiSearchState ?? this.offreEmploiSearchState,
      offreEmploiDetailsState: offreEmploiDetailsState ?? this.offreEmploiDetailsState,
      offreEmploiSearchResultsState: offreEmploiSearchResultsState ?? this.offreEmploiSearchResultsState,
      offreEmploiSearchParametersState: offreEmploiSearchParametersState ?? this.offreEmploiSearchParametersState,
      offreEmploiFavorisState: offreEmploiFavorisState ?? this.offreEmploiFavorisState,
      immersionFavorisState: immersionFavorisState ?? this.immersionFavorisState,
      favorisUpdateState: favorisUpdateState ?? this.favorisUpdateState,
      searchLocationState: searchLocationState ?? this.searchLocationState,
      searchMetierState: searchMetierState ?? this.searchMetierState,
      rendezvousState: rendezvousState ?? this.rendezvousState,
      immersionSearchState: immersionSearchState ?? this.immersionSearchState,
      immersionDetailsState: immersionDetailsState ?? this.immersionDetailsState,
      offreEmploiSavedSearchState: offreEmploiSavedSearchState ?? this.offreEmploiSavedSearchState,
      immersionSavedSearchState: immersionSavedSearchState ?? this.immersionSavedSearchState,
      configurationState: configurationState ?? this.configurationState,
      immersionSearchRequestState: immersionSearchRequestState ?? this.immersionSearchRequestState,
      savedSearchesState: savedSearchesState ?? this.savedSearchesState,
      savedSearchDeleteState: savedSearchDeleteState ?? this.savedSearchDeleteState,
      serviceCiviqueSearchResultState: serviceCiviqueSearchResultState ?? this.serviceCiviqueSearchResultState,
      serviceCiviqueDetailState: serviceCiviqueDetailState ?? this.serviceCiviqueDetailState,
    );
  }

  factory AppState.initialState({Configuration? configuration}) {
    return AppState(
      loginState: LoginNotInitializedState(),
      deepLinkState: DeepLinkState.notInitialized(),
      userActionListState: UserActionListNotInitializedState(),
      userActionCreateState: UserActionCreateNotInitializedState(),
      userActionUpdateState: UserActionNotUpdatingState(),
      userActionDeleteState: UserActionDeleteNotInitializedState(),
      chatStatusState: ChatStatusNotInitializedState(),
      chatState: ChatNotInitializedState(),
      offreEmploiSearchState: OffreEmploiSearchState.notInitialized(),
      offreEmploiDetailsState: State<OffreEmploiDetails>.notInitialized(),
      offreEmploiSearchResultsState: OffreEmploiSearchResultsState.notInitialized(),
      offreEmploiSearchParametersState: OffreEmploiSearchParametersState.notInitialized(),
      offreEmploiFavorisState: FavorisState<OffreEmploi>.notInitialized(),
      immersionFavorisState: FavorisState<Immersion>.notInitialized(),
      favorisUpdateState: FavorisUpdateState({}),
      searchLocationState: SearchLocationState([]),
      searchMetierState: SearchMetierState([]),
      rendezvousState: RendezvousNotInitializedState(),
      immersionSearchState: State<List<Immersion>>.notInitialized(),
      immersionDetailsState: State<ImmersionDetails>.notInitialized(),
      offreEmploiSavedSearchState: SavedSearchState<OffreEmploiSavedSearch>.notInitialized(),
      immersionSavedSearchState: SavedSearchState<ImmersionSavedSearch>.notInitialized(),
      configurationState: ConfigurationState(configuration),
      immersionSearchRequestState: EmptyImmersionSearchRequestState(),
      savedSearchesState: State<List<SavedSearch>>.notInitialized(),
      savedSearchDeleteState: SavedSearchDeleteNotInitializedState(),
      serviceCiviqueSearchResultState: ServiceCiviqueSearchResultNotInitializedState(),
      serviceCiviqueDetailState: ServiceCiviqueDetailNotInitializedState(),
    );
  }

  @override
  List<Object?> get props => [
    deepLinkState,
    userActionCreateState,
    userActionUpdateState,
    userActionDeleteState,
    chatStatusState,
    chatState,
    offreEmploiSearchState,
    offreEmploiDetailsState,
    offreEmploiSearchResultsState,
    offreEmploiSearchParametersState,
    offreEmploiFavorisState,
    favorisUpdateState,
    searchLocationState,
    searchMetierState,
    loginState,
    userActionListState,
    rendezvousState,
    immersionSearchState,
    immersionDetailsState,
    offreEmploiSavedSearchState,
    immersionSavedSearchState,
    immersionSearchRequestState,
    savedSearchesState,
    savedSearchDeleteState,
    serviceCiviqueDetailState,
  ];

  @override
  bool? get stringify => true;
}
