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
  final String explanationText;

  ImmersionDetailsViewModel._({
    required this.displayState,
    required this.metier,
    required this.nomEtablissement,
    required this.secteurActivite,
    required this.ville,
    required this.address,
    required this.explanationText,
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
      explanationText: immersion != null ? _explanationText(immersion) : '',
    );
  }
}

String _explanationText(ImmersionDetails immersion) {
  if (immersion.isVolontaire) {
    return Strings.immersionVolontaireExplanation + ' ' + _contractModeDetails(immersion.contact?.mode);
  }
  return Strings.immersionNonVolontaireExplanation;
}

String _contractModeDetails(ImmersionContactMode? mode) {
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
