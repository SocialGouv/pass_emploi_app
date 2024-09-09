import 'package:pass_emploi_app/models/preferences.dart';

class PreferencesRequestAction {}

class PreferencesLoadingAction {}

class PreferencesSuccessAction {
  final Preferences preferences;

  PreferencesSuccessAction(this.preferences);
}

class PreferencesFailureAction {}
