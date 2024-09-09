class PreferencesUpdateRequestAction {
  final bool favorisShared;

  PreferencesUpdateRequestAction(this.favorisShared);
}

class PreferencesUpdateLoadingAction {
  final bool favorisShared;

  PreferencesUpdateLoadingAction(this.favorisShared);
}

class PreferencesUpdateSuccessAction {
  final bool favorisShared;

  PreferencesUpdateSuccessAction(this.favorisShared);
}

class PreferencesUpdateFailureAction {
  final bool favorisShared;

  PreferencesUpdateFailureAction(this.favorisShared);
}
