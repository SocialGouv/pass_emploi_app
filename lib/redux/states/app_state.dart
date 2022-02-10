import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:pass_emploi_app/redux/states/chat_status_state.dart';
import 'package:pass_emploi_app/redux/states/configuration_state.dart';
import 'package:pass_emploi_app/redux/states/create_user_action_state.dart';
import 'package:pass_emploi_app/redux/states/deep_link_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/search_location_state.dart';
import 'package:pass_emploi_app/redux/states/search_metier_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:pass_emploi_app/redux/states/user_action_delete_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_update_state.dart';

import 'favoris_state.dart';
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
  final FavorisState<OffreEmploi> offreEmploiFavorisState;
  final FavorisState<Immersion> immersionFavorisState;
  final FavorisUpdateState favorisUpdateState;
  final SearchLocationState searchLocationState;
  final SearchMetierState searchMetierState;
  final State<User> loginState;
  final State<List<UserAction>> userActionState;
  final State<List<Rendezvous>> rendezvousState;
  final State<List<Immersion>> immersionSearchState;
  final State<ImmersionDetails> immersionDetailsState;
  final ConfigurationState configurationState;

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
    required this.immersionFavorisState,
    required this.favorisUpdateState,
    required this.searchLocationState,
    required this.searchMetierState,
    required this.loginState,
    required this.userActionState,
    required this.rendezvousState,
    required this.immersionSearchState,
    required this.immersionDetailsState,
    required this.configurationState,
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
    final FavorisState<OffreEmploi>? offreEmploiFavorisState,
    final FavorisState<Immersion>? immersionFavorisState,
    final FavorisUpdateState? favorisUpdateState,
    final SearchLocationState? searchLocationState,
    final SearchMetierState? searchMetierState,
    final State<User>? loginState,
    final State<List<UserAction>>? userActionState,
    final State<List<Rendezvous>>? rendezvousState,
    final State<OffreEmploiDetails>? offreEmploiDetailsState,
    final State<List<Immersion>>? immersionSearchState,
    final State<ImmersionDetails>? immersionDetailsState,
    final ConfigurationState? configurationState,
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
      immersionFavorisState: immersionFavorisState ?? this.immersionFavorisState,
      favorisUpdateState: favorisUpdateState ?? this.favorisUpdateState,
      searchLocationState: searchLocationState ?? this.searchLocationState,
      searchMetierState: searchMetierState ?? this.searchMetierState,
      loginState: loginState ?? this.loginState,
      userActionState: userActionState ?? this.userActionState,
      rendezvousState: rendezvousState ?? this.rendezvousState,
      immersionSearchState: immersionSearchState ?? this.immersionSearchState,
      immersionDetailsState: immersionDetailsState ?? this.immersionDetailsState,
      configurationState: configurationState ?? this.configurationState,
    );
  }

  factory AppState.initialState({Configuration? configuration}) {
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
        offreEmploiFavorisState: FavorisState<OffreEmploi>.notInitialized(),
        immersionFavorisState: FavorisState<Immersion>.notInitialized(),
        favorisUpdateState: FavorisUpdateState({}),
        searchLocationState: SearchLocationState([]),
        searchMetierState: SearchMetierState([]),
        loginState: State<User>.notInitialized(),
        userActionState: State<List<UserAction>>.notInitialized(),
        rendezvousState: State<List<Rendezvous>>.notInitialized(),
        immersionSearchState: State<List<Immersion>>.notInitialized(),
        immersionDetailsState: State<ImmersionDetails>.notInitialized(),
        configurationState: ConfigurationState(configuration));
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
        favorisUpdateState,
        searchLocationState,
        searchMetierState,
        loginState,
        userActionState,
        rendezvousState,
        immersionSearchState,
        immersionDetailsState,
      ];

  @override
  bool? get stringify => true;
}
