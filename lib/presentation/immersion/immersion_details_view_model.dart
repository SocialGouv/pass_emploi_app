import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_actions.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_contact.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/presentation/call_to_action.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/utils/uri_handler.dart';
import 'package:redux/redux.dart';

enum ImmersionDetailsPageDisplayState { SHOW_DETAILS, SHOW_INCOMPLETE_DETAILS, SHOW_LOADER, SHOW_ERROR }

class ImmersionDetailsViewModel extends Equatable {
  final ImmersionDetailsPageDisplayState displayState;
  final String id;
  final String title;
  final String companyName;
  final String secteurActivite;
  final bool fromEntrepriseAccueillante;
  final String ville;
  final String? address;
  final String? contactLabel;
  final String? contactInformation;
  final bool? withSecondaryCallToActions;
  final bool withContactForm;
  final bool withDataWarningMessage;
  final List<CallToAction>? secondaryCallToActions;
  final Function(String immersionId) onRetry;

  ImmersionDetailsViewModel._({
    required this.displayState,
    required this.id,
    required this.title,
    required this.companyName,
    required this.secteurActivite,
    required this.fromEntrepriseAccueillante,
    required this.ville,
    this.address,
    this.contactLabel,
    this.contactInformation,
    this.withSecondaryCallToActions,
    required this.withContactForm,
    required this.withDataWarningMessage,
    this.secondaryCallToActions,
    required this.onRetry,
  });

  factory ImmersionDetailsViewModel.create(Store<AppState> store, Platform platform) {
    final state = store.state.immersionDetailsState;
    if (state is ImmersionDetailsSuccessState) {
      final immersionDetails = state.immersion;
      final secondaryCallToActions = _secondaryCallToActions(immersionDetails, platform);
      final withContactForm = _withContactForm(immersionDetails);
      return _successViewModel(
        state,
        immersionDetails,
        secondaryCallToActions,
        store,
        withContactForm,
      );
    } else if (state is ImmersionDetailsIncompleteDataState) {
      final immersion = state.immersion;
      return _incompleteViewModel(immersion, store);
    } else {
      return _otherCasesViewModel(state, store);
    }
  }

  @override
  List<Object?> get props => [
        displayState,
        id,
        title,
        companyName,
        secteurActivite,
        ville,
        address,
        contactLabel,
        contactInformation,
        withDataWarningMessage,
        withContactForm,
      ];
}

ImmersionDetailsPageDisplayState _displayState(ImmersionDetailsState state) {
  if (state is ImmersionDetailsSuccessState) {
    return ImmersionDetailsPageDisplayState.SHOW_DETAILS;
  } else if (state is ImmersionDetailsLoadingState) {
    return ImmersionDetailsPageDisplayState.SHOW_LOADER;
  } else {
    return ImmersionDetailsPageDisplayState.SHOW_ERROR;
  }
}

ImmersionDetailsViewModel _successViewModel(
  ImmersionDetailsState state,
  ImmersionDetails immersionDetails,
  List<CallToAction> secondaryCallToActions,
  Store<AppState> store,
  bool withContactForm,
) {
  return ImmersionDetailsViewModel._(
    displayState: _displayState(state),
    id: immersionDetails.id,
    title: immersionDetails.metier,
    companyName: immersionDetails.companyName,
    secteurActivite: immersionDetails.secteurActivite,
    fromEntrepriseAccueillante: immersionDetails.fromEntrepriseAccueillante,
    ville: immersionDetails.ville,
    address: immersionDetails.address,
    contactLabel: _contactLabel(immersionDetails),
    contactInformation: immersionDetails.address,
    withSecondaryCallToActions: secondaryCallToActions.isNotEmpty,
    withContactForm: withContactForm,
    withDataWarningMessage: _withDataWarningMessage(immersionDetails),
    secondaryCallToActions: secondaryCallToActions,
    onRetry: (immersionId) => _retry(store, immersionId),
  );
}

ImmersionDetailsViewModel _incompleteViewModel(Immersion immersion, Store<AppState> store) {
  return ImmersionDetailsViewModel._(
    displayState: ImmersionDetailsPageDisplayState.SHOW_INCOMPLETE_DETAILS,
    id: immersion.id,
    title: immersion.metier,
    companyName: immersion.nomEtablissement,
    secteurActivite: immersion.secteurActivite,
    fromEntrepriseAccueillante: immersion.fromEntrepriseAccueillante,
    ville: immersion.ville,
    withContactForm: false,
    withDataWarningMessage: false,
    onRetry: (immersionId) => _retry(store, immersionId),
  );
}

ImmersionDetailsViewModel _otherCasesViewModel(ImmersionDetailsState state, Store<AppState> store) {
  return ImmersionDetailsViewModel._(
    displayState: _displayState(state),
    id: "",
    title: "",
    companyName: "",
    secteurActivite: "",
    fromEntrepriseAccueillante: false,
    ville: "",
    withContactForm: false,
    withDataWarningMessage: false,
    onRetry: (immersionId) => _retry(store, immersionId),
  );
}

String _contactLabel(ImmersionDetails immersion) {
  final contact = immersion.contact;
  if (contact == null) return '';
  final nameLabel = ('${contact.firstName} ${contact.lastName}').trim();
  if (contact.role.isEmpty) return nameLabel;
  return '$nameLabel\n${contact.role}';
}

bool _withContactForm(ImmersionDetails immersion) => immersion.contact?.mode == ImmersionContactMode.MAIL;

bool _withDataWarningMessage(ImmersionDetails immersion) {
  return immersion.contact?.mode == ImmersionContactMode.MAIL || immersion.contact?.mode == ImmersionContactMode.PHONE;
}

List<CallToAction> _secondaryCallToActions(ImmersionDetails immersion, Platform platform) {
  final mode = immersion.contact?.mode;
  if (mode == null || mode == ImmersionContactMode.INCONNU) {
    final mail = immersion.contact?.mail;
    final phone = immersion.contact?.phone;
    return [
      if (mail != null && mail.isNotEmpty)
        CallToAction(
          Strings.immersionEmailButton,
          UriHandler().mailUri(to: mail, subject: Strings.immersionEmailSubject),
          EvenementEngagement.OFFRE_IMMERSION_ENVOI_EMAIL,
          icon: AppIcons.outgoing_mail,
        ),
      if (phone != null && phone.isNotEmpty)
        CallToAction(
          Strings.immersionLocationButton,
          UriHandler().mapsUri(immersion.address, platform),
          EvenementEngagement.OFFRE_IMMERSION_LOCALISATION,
        ),
    ];
  } else {
    return [];
  }
}

void _retry(Store<AppState> store, String immersionId) => store.dispatch(ImmersionDetailsRequestAction(immersionId));
