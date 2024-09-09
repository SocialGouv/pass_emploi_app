abstract class PreferencesUpdateState {}

class PreferencesUpdateNotInitializedState extends PreferencesUpdateState {}

class PreferencesUpdateLoadingState extends PreferencesUpdateState {}

class PreferencesUpdateSuccessState extends PreferencesUpdateState {
  final bool favorisShared;

  PreferencesUpdateSuccessState(this.favorisShared);
}

class PreferencesUpdateFailureState extends PreferencesUpdateState {}
