import 'package:pass_emploi_app/network/json_serializable.dart';

class PutPreferencesRequest implements JsonSerializable {
  final bool? partageFavoris;
  final bool? pushNotificationAlertesOffres;
  final bool? pushNotificationMessages;
  final bool? pushNotificationCreationAction;
  final bool? pushNotificationRendezvousSessions;
  final bool? pushNotificationRappelActions;

  PutPreferencesRequest({
    this.partageFavoris,
    this.pushNotificationAlertesOffres,
    this.pushNotificationMessages,
    this.pushNotificationCreationAction,
    this.pushNotificationRendezvousSessions,
    this.pushNotificationRappelActions,
  });

  @override
  Map<String, dynamic> toJson() => {
        if (partageFavoris != null) "partageFavoris": partageFavoris,
        if (pushNotificationAlertesOffres != null) "alertesOffres": pushNotificationAlertesOffres,
        if (pushNotificationMessages != null) "messages": pushNotificationMessages,
        if (pushNotificationCreationAction != null) "creationActionConseiller": pushNotificationCreationAction,
        if (pushNotificationRendezvousSessions != null) "rendezVousSessions": pushNotificationRendezvousSessions,
        if (pushNotificationRappelActions != null) "rappelActions": pushNotificationRappelActions,
      };
}
