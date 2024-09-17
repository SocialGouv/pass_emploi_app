import 'package:pass_emploi_app/models/preferences.dart';

sealed class PreferencesState {}

class PreferencesNotInitializedState extends PreferencesState {}

class PreferencesLoadingState extends PreferencesState {}

class PreferencesSuccessState extends PreferencesState {
  final Preferences preferences;

  PreferencesSuccessState(this.preferences);
}

class PreferencesFailureState extends PreferencesState {}
