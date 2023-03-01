import 'package:pass_emploi_app/models/diagoriente_urls.dart';

class DiagorientePreferencesMetierRequestAction {}

class DiagorientePreferencesMetierLoadingAction {}

class DiagorientePreferencesMetierSuccessAction {
  final DiagorienteUrls result;

  DiagorientePreferencesMetierSuccessAction(this.result);
}

class DiagorientePreferencesMetierFailureAction {}

class DiagorientePreferencesMetierResetAction {}
