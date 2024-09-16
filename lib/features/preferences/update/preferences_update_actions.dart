class PreferencesUpdateRequestAction {
  final bool? partageFavoris;
  final bool? pushNotificationAlertesOffres;
  final bool? pushNotificationMessages;
  final bool? pushNotificationCreationAction;
  final bool? pushNotificationRendezvousSessions;
  final bool? pushNotificationRappelActions;

  PreferencesUpdateRequestAction({
    this.partageFavoris,
    this.pushNotificationAlertesOffres,
    this.pushNotificationMessages,
    this.pushNotificationCreationAction,
    this.pushNotificationRendezvousSessions,
    this.pushNotificationRappelActions,
  });
}

class PreferencesUpdateLoadingAction {}

class PreferencesUpdateSuccessAction {}

class PreferencesUpdateFailureAction {}
