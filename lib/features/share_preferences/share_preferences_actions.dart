import 'package:pass_emploi_app/models/share_preferences.dart';

class SharePreferencesRequestAction {}

class SharePreferencesLoadingAction {}

class SharePreferencesSuccessAction {
  final SharePreferences preferences;

  SharePreferencesSuccessAction(this.preferences);
}

class SharePreferencesFailureAction {}