import 'package:pass_emploi_app/models/diagoriente_urls.dart';

class DiagorientePreferencesMetierRequestAction {}

class DiagorientePreferencesMetierLoadingAction {}

class DiagorientePreferencesMetierSuccessAction {
  final DiagorienteUrls urls;
  final bool aDesMetiersFavoris;

  DiagorientePreferencesMetierSuccessAction(this.urls, this.aDesMetiersFavoris);
}

class DiagorientePreferencesMetierFailureAction {}

class DiagorientePreferencesMetierResetAction {}
