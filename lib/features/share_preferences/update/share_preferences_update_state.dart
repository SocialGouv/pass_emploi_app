abstract class SharePreferencesUpdateState {}

class SharePreferencesUpdateNotInitializedState extends SharePreferencesUpdateState {}

class SharePreferencesUpdateLoadingState extends SharePreferencesUpdateState {}

class SharePreferencesUpdateSuccessState extends SharePreferencesUpdateState {
  final bool favorisShared;

  SharePreferencesUpdateSuccessState(this.favorisShared);
}

class SharePreferencesUpdateFailureState extends SharePreferencesUpdateState {}
