import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_contact.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/presentation/call_to_action.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/immersion_details_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
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
  final String ville;
  final String? address;
  final String? explanationLabel;
  final String? contactLabel;
  final String? contactInformation;
  final bool? withSecondaryCallToActions;
  final CallToAction? mainCallToAction;
  final List<CallToAction>? secondaryCallToActions;
  final Function(String immersionId) onRetry;

  ImmersionDetailsViewModel._({
    required this.displayState,
    required this.id,
    required this.title,
    required this.companyName,
    required this.secteurActivite,
    required this.ville,
    this.address,
    this.explanationLabel,
    this.contactLabel,
    this.contactInformation,
    this.withSecondaryCallToActions,
    this.mainCallToAction,
    this.secondaryCallToActions,
    required this.onRetry,
  });

  factory ImmersionDetailsViewModel.create(Store<AppState> store, Platform platform) {
    final state = store.state.immersionDetailsState;
    if (state.isSuccess()) {
      final immersionDetails = state.getResultOrThrow();
      final mainCallToAction = _mainCallToAction(immersionDetails, platform);
      final secondaryCallToActions = _secondaryCallToActions(immersionDetails, platform);
      return _successViewModel(state, immersionDetails, mainCallToAction, secondaryCallToActions, store);
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
        explanationLabel,
        contactLabel,
        contactInformation,
      ];
}

ImmersionDetailsPageDisplayState _displayState(State<ImmersionDetails> offreEmploiDetailsState) {
  if (offreEmploiDetailsState.isSuccess()) {
    return ImmersionDetailsPageDisplayState.SHOW_DETAILS;
  } else if (offreEmploiDetailsState.isLoading()) {
    return ImmersionDetailsPageDisplayState.SHOW_LOADER;
  } else {
    return ImmersionDetailsPageDisplayState.SHOW_ERROR;
  }
}

ImmersionDetailsViewModel _successViewModel(State<ImmersionDetails> state, ImmersionDetails immersionDetails,
    CallToAction? mainCallToAction, List<CallToAction> secondaryCallToActions, Store<AppState> store) {
  return ImmersionDetailsViewModel._(
    displayState: _displayState(state),
    id: immersionDetails.id,
    title: immersionDetails.metier,
    companyName: immersionDetails.companyName,
    secteurActivite: immersionDetails.secteurActivite,
    ville: immersionDetails.ville,
    address: immersionDetails.address,
    explanationLabel: _explanationLabel(immersionDetails),
    contactLabel: _contactLabel(immersionDetails),
    contactInformation: _contactInformation(immersionDetails),
    withSecondaryCallToActions: secondaryCallToActions.isNotEmpty,
    mainCallToAction: mainCallToAction,
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
    ville: immersion.ville,
    onRetry: (immersionId) => _retry(store, immersionId),
  );
}

ImmersionDetailsViewModel _otherCasesViewModel(State<ImmersionDetails> state, Store<AppState> store) {
  return ImmersionDetailsViewModel._(
    displayState: _displayState(state),
    id: "",
    title: "",
    companyName: "",
    secteurActivite: "",
    ville: "",
    onRetry: (immersionId) => _retry(store, immersionId),
  );
}

String _explanationLabel(ImmersionDetails immersion) {
  if (immersion.isVolontaire) {
    return Strings.immersionVolontaireExplanation + ' ' + _contactModeLabel(immersion.contact?.mode);
  }
  return Strings.immersionNonVolontaireExplanation;
}

String _contactModeLabel(ImmersionContactMode? mode) {
  switch (mode) {
    case ImmersionContactMode.MAIL:
      return Strings.immersionMailContactModeExplanation;
    case ImmersionContactMode.PHONE:
      return Strings.immersionPhoneContactModeExplanation;
    case ImmersionContactMode.PRESENTIEL:
      return Strings.immersionInPersonContactModeExplanation;
    case ImmersionContactMode.INCONNU:
    case null:
      return Strings.immersionUnknownContactModeExplanation;
  }
}

String _contactLabel(ImmersionDetails immersion) {
  final contact = immersion.contact;
  if (contact == null) return '';
  final nameLabel = (contact.firstName + ' ' + contact.lastName).trim();
  if (contact.role.isEmpty) return nameLabel;
  return nameLabel + '\n' + contact.role;
}

String _contactInformation(ImmersionDetails immersion) {
  var contactInformation = immersion.address;
  final mode = immersion.contact?.mode;
  final mail = immersion.contact != null ? immersion.contact!.mail : '';
  final phone = immersion.contact != null ? immersion.contact!.phone : '';
  if (mail.isNotEmpty && ([ImmersionContactMode.INCONNU, ImmersionContactMode.MAIL].contains(mode))) {
    contactInformation += "\n\n" + mail;
  }
  if (phone.isNotEmpty && ([ImmersionContactMode.INCONNU, ImmersionContactMode.PHONE].contains(mode))) {
    contactInformation += "\n\n" + phone;
  }
  return contactInformation;
}

CallToAction _mainCallToAction(ImmersionDetails immersion, Platform platform) {
  final contact = immersion.contact;
  if (contact != null && contact.mode == ImmersionContactMode.INCONNU && contact.phone.isNotEmpty) {
    return CallToAction(
      Strings.immersionPhoneButton,
      UriHandler().phoneUri(contact.phone),
      EventType.OFFRE_IMMERSION_APPEL,
    );
  } else if (contact != null && contact.mode == ImmersionContactMode.PHONE) {
    return CallToAction(
      Strings.immersionPhoneButton,
      UriHandler().phoneUri(contact.phone),
      EventType.OFFRE_IMMERSION_APPEL,
    );
  } else if (contact != null && contact.mode == ImmersionContactMode.MAIL) {
    return CallToAction(
      Strings.immersionEmailButton,
      UriHandler().mailUri(to: contact.mail, subject: Strings.immersionEmailSubject),
      EventType.OFFRE_IMMERSION_ENVOI_EMAIL,
    );
  } else {
    return CallToAction(
      Strings.immersionLocationButton,
      UriHandler().mapsUri(immersion.address, platform),
      EventType.OFFRE_IMMERSION_LOCALISATION,
    );
  }
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
          EventType.OFFRE_IMMERSION_ENVOI_EMAIL,
          drawableRes: Drawables.icMail,
        ),
      if (phone != null && phone.isNotEmpty)
        CallToAction(
          Strings.immersionLocationButton,
          UriHandler().mapsUri(immersion.address, platform),
          EventType.OFFRE_IMMERSION_LOCALISATION,
        ),
    ];
  } else {
    return [];
  }
}

void _retry(Store<AppState> store, String immersionId) => store.dispatch(ImmersionDetailsAction.request(immersionId));
