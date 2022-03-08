import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_state.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';
import 'package:pass_emploi_app/features/saved_search/delete/saved_search_delete_state.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_state.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_state.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/states/configuration_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/search_location_state.dart';
import 'package:pass_emploi_app/redux/states/search_metier_state.dart';

import '../../features/favori/list/favori_list_state.dart';
import '../../features/favori/update/favori_update_state.dart';
import '../../features/immersion/search/immersion_search_state.dart';
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
  final OffreEmploiDetailsState offreEmploiDetailsState;
  final OffreEmploiSearchResultsState offreEmploiSearchResultsState;
  final OffreEmploiSearchParametersState offreEmploiSearchParametersState;
  final FavoriListState<OffreEmploi> offreEmploiFavorisState;
  final FavoriListState<Immersion> immersionFavorisState;
  final FavorisUpdateState favorisUpdateState;
  final SearchLocationState searchLocationState;
  final SearchMetierState searchMetierState;
  final RendezvousState rendezvousState;
  final ImmersionSearchState immersionSearchRequestState;
  final ImmersionListState immersionListState;
  final ImmersionDetailsState immersionDetailsState;
  final SavedSearchCreateState<OffreEmploiSavedSearch> offreEmploiSavedSearchCreateState;
  final SavedSearchCreateState<ImmersionSavedSearch> immersionSavedSearchCreateState;
  final ConfigurationState configurationState;
  final SavedSearchListState savedSearchListState;
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
    required this.immersionListState,
    required this.immersionDetailsState,
    required this.offreEmploiSavedSearchCreateState,
    required this.immersionSavedSearchCreateState,
    required this.configurationState,
    required this.immersionSearchRequestState,
    required this.savedSearchListState,
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
    final FavoriListState<OffreEmploi>? offreEmploiFavorisState,
    final FavoriListState<Immersion>? immersionFavorisState,
    final FavorisUpdateState? favorisUpdateState,
    final SearchLocationState? searchLocationState,
    final SearchMetierState? searchMetierState,
    final RendezvousState? rendezvousState,
    final OffreEmploiDetailsState? offreEmploiDetailsState,
    final ImmersionListState? immersionListState,
    final ImmersionDetailsState? immersionDetailsState,
    final SavedSearchCreateState<OffreEmploiSavedSearch>? offreEmploiSavedSearchCreateState,
    final SavedSearchCreateState<ImmersionSavedSearch>? immersionSavedSearchCreateState,
    final ConfigurationState? configurationState,
    final ImmersionSearchState? immersionSearchRequestState,
    final SavedSearchListState? savedSearchListState,
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
      immersionSearchRequestState: immersionSearchRequestState ?? this.immersionSearchRequestState,
      immersionListState: immersionListState ?? this.immersionListState,
      immersionDetailsState: immersionDetailsState ?? this.immersionDetailsState,
      offreEmploiSavedSearchCreateState: offreEmploiSavedSearchCreateState ?? this.offreEmploiSavedSearchCreateState,
      immersionSavedSearchCreateState: immersionSavedSearchCreateState ?? this.immersionSavedSearchCreateState,
      configurationState: configurationState ?? this.configurationState,
      savedSearchListState: savedSearchListState ?? this.savedSearchListState,
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
      offreEmploiDetailsState: OffreEmploiDetailsNotInitializedState(),
      offreEmploiSearchResultsState: OffreEmploiSearchResultsState.notInitialized(),
      offreEmploiSearchParametersState: OffreEmploiSearchParametersState.notInitialized(),
      offreEmploiFavorisState: FavoriListState<OffreEmploi>.notInitialized(),
      immersionFavorisState: FavoriListState<Immersion>.notInitialized(),
      favorisUpdateState: FavorisUpdateState({}),
      searchLocationState: SearchLocationState([]),
      searchMetierState: SearchMetierState([]),
      rendezvousState: RendezvousNotInitializedState(),
      immersionListState: ImmersionListNotInitializedState(),
      immersionDetailsState: ImmersionDetailsNotInitializedState(),
      offreEmploiSavedSearchCreateState: SavedSearchCreateState<OffreEmploiSavedSearch>.notInitialized(),
      immersionSavedSearchCreateState: SavedSearchCreateState<ImmersionSavedSearch>.notInitialized(),
      configurationState: ConfigurationState(configuration),
      immersionSearchRequestState: ImmersionSearchEmptyState(),
      savedSearchListState: SavedSearchListNotInitializedState(),
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
        immersionListState,
        immersionDetailsState,
        offreEmploiSavedSearchCreateState,
        immersionSavedSearchCreateState,
        immersionSearchRequestState,
        savedSearchListState,
        savedSearchDeleteState,
        serviceCiviqueDetailState,
      ];

  @override
  bool? get stringify => true;
}
