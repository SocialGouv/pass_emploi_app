import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_state.dart';
import 'package:pass_emploi_app/models/immersion_contact.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/presentation/call_to_action.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/utils/uri_handler.dart';
import 'package:redux/redux.dart';

class ImmersionContactViewModel extends Equatable {
  final CallToAction callToAction;

  ImmersionContactViewModel({
    required this.callToAction,
  });

  factory ImmersionContactViewModel.create({
    required Store<AppState> store,
    required Platform platform,
  }) {
    return ImmersionContactViewModel(
      callToAction: _callToAction(_getImmersionFromState(store), platform),
    );
  }

  @override
  List<Object?> get props => [
        callToAction,
      ];
}

ImmersionDetails _getImmersionFromState(Store<AppState> store) {
  final state = store.state.immersionDetailsState;
  if (state is! ImmersionDetailsSuccessState) throw Exception('Invalid state.');
  return state.immersion;
}

CallToAction _callToAction(ImmersionDetails immersion, Platform platform) {
  final contact = immersion.contact;
  final contactIsMail = contact?.mode == ImmersionContactMode.MAIL;
  final contactModeIsInconnuWithPhone =
      contact?.mode == ImmersionContactMode.INCONNU && contact?.phone.isNotEmpty == true;
  final contactModeIsPhone = contact?.mode == ImmersionContactMode.PHONE;
  if (contactIsMail) {
    throw Exception('Invalid contact mode.');
  } else if (contactModeIsInconnuWithPhone || contactModeIsPhone) {
    return CallToAction(
      Strings.immersionPhoneButton,
      UriHandler().phoneUri(contact!.phone),
      EvenementEngagement.OFFRE_IMMERSION_APPEL,
    );
  } else {
    return CallToAction(
      Strings.immersionLocationButton,
      UriHandler().mapsUri(immersion.address, platform),
      EvenementEngagement.OFFRE_IMMERSION_LOCALISATION,
    );
  }
}
