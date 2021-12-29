import 'package:pass_emploi_app/models/immersion_contact.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class ImmersionDetailsViewModel {
  final DisplayState displayState;
  final String metier;
  final String nomEtablissement;
  final String secteurActivite;
  final String ville;
  final String address;
  final String explanationLabel;
  final String contactLabel;
  final String contactInformation;

  ImmersionDetailsViewModel._({
    required this.displayState,
    required this.metier,
    required this.nomEtablissement,
    required this.secteurActivite,
    required this.ville,
    required this.address,
    required this.explanationLabel,
    required this.contactLabel,
    required this.contactInformation,
  });

  factory ImmersionDetailsViewModel.create(Store<AppState> store) {
    final state = store.state.immersionDetailsState;
    final immersion = state.isSuccess() ? state.getResultOrThrow() : null;
    return ImmersionDetailsViewModel._(
      displayState: displayStateFromState(state),
      metier: immersion?.metier ?? '',
      nomEtablissement: immersion?.nomEtablissement ?? '',
      secteurActivite: immersion?.secteurActivite ?? '',
      ville: immersion?.ville ?? '',
      address: immersion?.address ?? '',
      explanationLabel: immersion != null ? _explanationLabel(immersion) : '',
      contactLabel: immersion != null ? _contactLabel(immersion) : '',
      contactInformation: immersion != null ? _contactInformation(immersion) : '',
    );
  }
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
