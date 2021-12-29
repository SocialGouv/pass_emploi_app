import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/immersion_contact.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/presentation/call_to_action.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/utils/uri_handler.dart';
import 'package:redux/redux.dart';

class ImmersionDetailsViewModel extends Equatable {
  final DisplayState displayState;
  final String title;
  final String companyName;
  final String secteurActivite;
  final String ville;
  final String address;
  final String explanationLabel;
  final String contactLabel;
  final String contactInformation;
  final bool withMainCallToAction;
  final bool withSecondaryCallToActions;
  final CallToAction? mainCallToAction;
  final List<CallToAction> secondaryCallToActions;
  final Function(String immersionId) onRetry;

  ImmersionDetailsViewModel._({
    required this.displayState,
    required this.title,
    required this.companyName,
    required this.secteurActivite,
    required this.ville,
    required this.address,
    required this.explanationLabel,
    required this.contactLabel,
    required this.contactInformation,
    required this.withMainCallToAction,
    required this.withSecondaryCallToActions,
    required this.mainCallToAction,
    required this.secondaryCallToActions,
    required this.onRetry,
  });

  factory ImmersionDetailsViewModel.create(Store<AppState> store, Platform platform) {
    final state = store.state.immersionDetailsState;
    final immersion = state.isSuccess() ? state.getResultOrThrow() : null;
    final mainCallToAction = immersion != null ? _mainCallToAction(immersion, platform) : null;
    final secondaryCallToActions = immersion != null ? _secondaryCallToActions(immersion, platform) : <CallToAction>[];
    return ImmersionDetailsViewModel._(
      displayState: displayStateFromState(state),
      title: immersion?.metier ?? '',
      companyName: immersion?.companyName ?? '',
      secteurActivite: immersion?.secteurActivite ?? '',
      ville: immersion?.ville ?? '',
      address: immersion?.address ?? '',
      explanationLabel: immersion != null ? _explanationLabel(immersion) : '',
      contactLabel: immersion != null ? _contactLabel(immersion) : '',
      contactInformation: immersion != null ? _contactInformation(immersion) : '',
      withMainCallToAction: mainCallToAction != null,
      withSecondaryCallToActions: secondaryCallToActions.isNotEmpty,
      mainCallToAction: mainCallToAction,
      secondaryCallToActions: secondaryCallToActions,
      onRetry: (immersionId) => store.dispatch(ImmersionDetailsAction.request(immersionId)),
    );
  }

  @override
  List<Object?> get props => [
        displayState,
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
    case ImmersionContactMode.IN_PERSON:
      return Strings.immersionInPersonContactModeExplanation;
    case ImmersionContactMode.UNKNOWN:
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
  var contractInformation = immersion.address;
  if (immersion.contact?.mail.isNotEmpty == true) contractInformation += "\n" + immersion.contact!.mail;
  if (immersion.contact?.phone.isNotEmpty == true) contractInformation += "\n" + immersion.contact!.phone;
  return contractInformation;
}

CallToAction? _mainCallToAction(ImmersionDetails immersion, Platform platform) {
  final contact = immersion.contact;
  if (contact != null) {
    if (contact.mode == ImmersionContactMode.UNKNOWN && contact.phone.isNotEmpty) {
      return CallToAction(Strings.immersionPhoneButton, UriHandler().phoneUri(contact.phone));
    } else if (contact.mode == ImmersionContactMode.PHONE) {
      return CallToAction(Strings.immersionPhoneButton, UriHandler().phoneUri(contact.phone));
    } else if (contact.mode == ImmersionContactMode.MAIL) {
      return CallToAction(
        Strings.immersionEmailButton,
        UriHandler().mailUri(to: contact.mail, subject: Strings.immersionEmailSubject),
      );
    } else if (contact.mode == ImmersionContactMode.IN_PERSON) {
      return CallToAction(Strings.immersionLocationButton, UriHandler().mapsUri(immersion.address, platform));
    }
  }
  return null;
}

List<CallToAction> _secondaryCallToActions(ImmersionDetails immersion, Platform platform) {
  final mode = immersion.contact?.mode;
  if (mode == null || mode == ImmersionContactMode.UNKNOWN) {
    final mail = immersion.contact?.mail;
    return [
      if (mail != null && mail.isNotEmpty)
        CallToAction(
          Strings.immersionEmailButton,
          UriHandler().mailUri(to: mail, subject: Strings.immersionEmailSubject),
          drawableId: Drawables.icMail,
        ),
      CallToAction(Strings.immersionLocationButton, UriHandler().mapsUri(immersion.address, platform)),
    ];
  } else {
    return [];
  }
}
