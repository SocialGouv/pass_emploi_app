sealed class PreferencesUpdateState {}

class PreferencesUpdateNotInitializedState extends PreferencesUpdateState {}

class PreferencesUpdateLoadingState extends PreferencesUpdateState {}

class PreferencesUpdateSuccessState extends PreferencesUpdateState {}

class PreferencesUpdateFailureState extends PreferencesUpdateState {}
