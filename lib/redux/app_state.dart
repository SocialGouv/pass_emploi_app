import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/configuration/configuration_state.dart';
import 'package:pass_emploi_app/features/conseiller/conseiller_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_state.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_state.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/immersion/parameters/immersion_search_parameters_state.dart';
import 'package:pass_emploi_app/features/location/search_location_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/metier/search_metier_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_state.dart';
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
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/models/service_civique.dart';

class AppState extends Equatable {
  final ConfigurationState configurationState;
  final LoginState loginState;
  final DeepLinkState deepLinkState;
  final UserActionListState userActionListState;
  final UserActionCreateState userActionCreateState;
  final UserActionUpdateState userActionUpdateState;
  final UserActionDeleteState userActionDeleteState;
  final UserActionPEListState userActionPEListState;
  final ConseillerState conseillerState;
  final ChatStatusState chatStatusState;
  final ChatState chatState;
  final OffreEmploiSearchState offreEmploiSearchState;
  final OffreEmploiDetailsState offreEmploiDetailsState;
  final OffreEmploiListState offreEmploiListState;
  final OffreEmploiSearchParametersState offreEmploiSearchParametersState;
  final FavoriListState<OffreEmploi> offreEmploiFavorisState;
  final FavoriListState<Immersion> immersionFavorisState;
  final FavoriListState<ServiceCivique> serviceCiviqueFavorisState;
  final FavoriUpdateState favoriUpdateState;
  final SearchLocationState searchLocationState;
  final SearchMetierState searchMetierState;
  final RendezvousState rendezvousState;
  final ImmersionListState immersionListState;
  final ImmersionDetailsState immersionDetailsState;
  final SavedSearchCreateState<OffreEmploiSavedSearch> offreEmploiSavedSearchCreateState;
  final SavedSearchCreateState<ImmersionSavedSearch> immersionSavedSearchCreateState;
  final SavedSearchCreateState<ServiceCiviqueSavedSearch> serviceCiviqueSavedSearchCreateState;
  final ImmersionSearchParametersState immersionSearchParametersState;
  final SavedSearchListState savedSearchListState;
  final SavedSearchDeleteState savedSearchDeleteState;
  final ServiceCiviqueSearchResultState serviceCiviqueSearchResultState;
  final ServiceCiviqueDetailState serviceCiviqueDetailState;
  final bool demoState;

  AppState({
    required this.configurationState,
    required this.loginState,
    required this.deepLinkState,
    required this.userActionListState,
    required this.userActionCreateState,
    required this.userActionUpdateState,
    required this.userActionDeleteState,
    required this.userActionPEListState,
    required this.conseillerState,
    required this.chatStatusState,
    required this.chatState,
    required this.offreEmploiSearchState,
    required this.offreEmploiDetailsState,
    required this.offreEmploiListState,
    required this.offreEmploiSearchParametersState,
    required this.offreEmploiFavorisState,
    required this.immersionFavorisState,
    required this.serviceCiviqueFavorisState,
    required this.favoriUpdateState,
    required this.searchLocationState,
    required this.searchMetierState,
    required this.rendezvousState,
    required this.immersionListState,
    required this.immersionDetailsState,
    required this.offreEmploiSavedSearchCreateState,
    required this.immersionSavedSearchCreateState,
    required this.serviceCiviqueSavedSearchCreateState,
    required this.immersionSearchParametersState,
    required this.savedSearchListState,
    required this.savedSearchDeleteState,
    required this.serviceCiviqueSearchResultState,
    required this.serviceCiviqueDetailState,
    required this.demoState,
  });

  AppState copyWith({
    final LoginState? loginState,
    final UserActionListState? userActionListState,
    final UserActionCreateState? userActionCreateState,
    final UserActionUpdateState? userActionUpdateState,
    final UserActionDeleteState? userActionDeleteState,
    final UserActionPEListState? userActionPEListState,
    final ConseillerState? conseillerState,
    final ChatStatusState? chatStatusState,
    final ChatState? chatState,
    final OffreEmploiSearchState? offreEmploiSearchState,
    final DeepLinkState? deepLinkState,
    final OffreEmploiListState? offreEmploiListState,
    final OffreEmploiSearchParametersState? offreEmploiSearchParametersState,
    final FavoriListState<OffreEmploi>? offreEmploiFavorisState,
    final FavoriListState<Immersion>? immersionFavorisState,
    final FavoriListState<ServiceCivique>? serviceCiviqueFavorisState,
    final FavoriUpdateState? favoriUpdateState,
    final SearchLocationState? searchLocationState,
    final SearchMetierState? searchMetierState,
    final RendezvousState? rendezvousState,
    final OffreEmploiDetailsState? offreEmploiDetailsState,
    final ImmersionListState? immersionListState,
    final ImmersionDetailsState? immersionDetailsState,
    final SavedSearchCreateState<OffreEmploiSavedSearch>? offreEmploiSavedSearchCreateState,
    final SavedSearchCreateState<ImmersionSavedSearch>? immersionSavedSearchCreateState,
    final SavedSearchCreateState<ServiceCiviqueSavedSearch>? serviceCiviqueSavedSearchCreateState,
    final ConfigurationState? configurationState,
    final ImmersionSearchParametersState? immersionSearchParametersState,
    final SavedSearchListState? savedSearchListState,
    final SavedSearchDeleteState? savedSearchDeleteState,
    final ServiceCiviqueSearchResultState? serviceCiviqueSearchResultState,
    final ServiceCiviqueDetailState? serviceCiviqueDetailState,
    final bool? demoState,
  }) {
    return AppState(
      loginState: loginState ?? this.loginState,
      deepLinkState: deepLinkState ?? this.deepLinkState,
      userActionListState: userActionListState ?? this.userActionListState,
      userActionCreateState: userActionCreateState ?? this.userActionCreateState,
      userActionUpdateState: userActionUpdateState ?? this.userActionUpdateState,
      userActionDeleteState: userActionDeleteState ?? this.userActionDeleteState,
      userActionPEListState: userActionPEListState ?? this.userActionPEListState,
      conseillerState: conseillerState ?? this.conseillerState,
      chatStatusState: chatStatusState ?? this.chatStatusState,
      chatState: chatState ?? this.chatState,
      offreEmploiSearchState: offreEmploiSearchState ?? this.offreEmploiSearchState,
      offreEmploiDetailsState: offreEmploiDetailsState ?? this.offreEmploiDetailsState,
      offreEmploiListState: offreEmploiListState ?? this.offreEmploiListState,
      offreEmploiSearchParametersState: offreEmploiSearchParametersState ?? this.offreEmploiSearchParametersState,
      offreEmploiFavorisState: offreEmploiFavorisState ?? this.offreEmploiFavorisState,
      immersionFavorisState: immersionFavorisState ?? this.immersionFavorisState,
      serviceCiviqueFavorisState: serviceCiviqueFavorisState ?? this.serviceCiviqueFavorisState,
      favoriUpdateState: favoriUpdateState ?? this.favoriUpdateState,
      searchLocationState: searchLocationState ?? this.searchLocationState,
      searchMetierState: searchMetierState ?? this.searchMetierState,
      rendezvousState: rendezvousState ?? this.rendezvousState,
      immersionListState: immersionListState ?? this.immersionListState,
      immersionDetailsState: immersionDetailsState ?? this.immersionDetailsState,
      offreEmploiSavedSearchCreateState: offreEmploiSavedSearchCreateState ?? this.offreEmploiSavedSearchCreateState,
      immersionSavedSearchCreateState: immersionSavedSearchCreateState ?? this.immersionSavedSearchCreateState,
      serviceCiviqueSavedSearchCreateState: serviceCiviqueSavedSearchCreateState ?? this.serviceCiviqueSavedSearchCreateState,
      configurationState: configurationState ?? this.configurationState,
      immersionSearchParametersState: immersionSearchParametersState ?? this.immersionSearchParametersState,
      savedSearchListState: savedSearchListState ?? this.savedSearchListState,
      savedSearchDeleteState: savedSearchDeleteState ?? this.savedSearchDeleteState,
      serviceCiviqueSearchResultState: serviceCiviqueSearchResultState ?? this.serviceCiviqueSearchResultState,
      serviceCiviqueDetailState: serviceCiviqueDetailState ?? this.serviceCiviqueDetailState,
      demoState: demoState ?? this.demoState,
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
      userActionPEListState: UserActionPEListNotInitializedState(),
      conseillerState: ConseillerNotInitializedState(),
      chatStatusState: ChatStatusNotInitializedState(),
      chatState: ChatNotInitializedState(),
      offreEmploiSearchState: OffreEmploiSearchState.notInitialized(),
      offreEmploiDetailsState: OffreEmploiDetailsNotInitializedState(),
      offreEmploiListState: OffreEmploiListState.notInitialized(),
      offreEmploiSearchParametersState: OffreEmploiSearchParametersState.notInitialized(),
      offreEmploiFavorisState: FavoriListState<OffreEmploi>.notInitialized(),
      immersionFavorisState: FavoriListState<Immersion>.notInitialized(),
      serviceCiviqueFavorisState: FavoriListState<ServiceCivique>.notInitialized(),
      favoriUpdateState: FavoriUpdateState({}),
      searchLocationState: SearchLocationState([]),
      searchMetierState: SearchMetierState([]),
      rendezvousState: RendezvousNotInitializedState(),
      immersionListState: ImmersionListNotInitializedState(),
      immersionDetailsState: ImmersionDetailsNotInitializedState(),
      offreEmploiSavedSearchCreateState: SavedSearchCreateState<OffreEmploiSavedSearch>.notInitialized(),
      immersionSavedSearchCreateState: SavedSearchCreateState<ImmersionSavedSearch>.notInitialized(),
      serviceCiviqueSavedSearchCreateState: SavedSearchCreateState<ServiceCiviqueSavedSearch>.notInitialized(),
      configurationState: ConfigurationState(configuration),
      immersionSearchParametersState: ImmersionSearchParametersNotInitializedState(),
      savedSearchListState: SavedSearchListNotInitializedState(),
      savedSearchDeleteState: SavedSearchDeleteNotInitializedState(),
      serviceCiviqueSearchResultState: ServiceCiviqueSearchResultNotInitializedState(),
      serviceCiviqueDetailState: ServiceCiviqueDetailNotInitializedState(),
      demoState: false,
    );
  }

  @override
  List<Object?> get props => [
        deepLinkState,
        userActionCreateState,
        userActionUpdateState,
        userActionDeleteState,
        conseillerState,
        chatStatusState,
        chatState,
        offreEmploiSearchState,
        offreEmploiDetailsState,
        offreEmploiListState,
        offreEmploiSearchParametersState,
        offreEmploiFavorisState,
        favoriUpdateState,
        searchLocationState,
        searchMetierState,
        loginState,
        userActionListState,
        userActionPEListState,
        rendezvousState,
        immersionListState,
        immersionDetailsState,
        offreEmploiSavedSearchCreateState,
        immersionSavedSearchCreateState,
        immersionSearchParametersState,
        savedSearchListState,
        savedSearchDeleteState,
        serviceCiviqueDetailState,
        demoState,
      ];

  @override
  bool? get stringify => true;
}
