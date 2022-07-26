import 'package:pass_emploi_app/models/share_preferences.dart';

abstract class SharePreferencesState {}

class  SharePreferencesNotInitializedState extends SharePreferencesState {}

class SharePreferencesLoadingState extends SharePreferencesState {}

class SharePreferencesSuccessState extends SharePreferencesState {
  final SharePreferences preferences;

  SharePreferencesSuccessState(this.preferences);
}

class SharePreferencesFailureState extends SharePreferencesState {}