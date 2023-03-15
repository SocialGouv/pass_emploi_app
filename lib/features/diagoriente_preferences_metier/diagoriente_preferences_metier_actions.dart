import 'package:pass_emploi_app/models/diagoriente_urls.dart';
import 'package:pass_emploi_app/models/metier.dart';

class DiagorientePreferencesMetierRequestAction {}

class DiagorientePreferencesMetierLoadingAction {}

class DiagorientePreferencesMetierSuccessAction {
  final DiagorienteUrls urls;
  final List<Metier> metiersFavoris;

  DiagorientePreferencesMetierSuccessAction(this.urls, this.metiersFavoris);
}

class DiagorientePreferencesMetierFailureAction {}

class DiagorientePreferencesMetierResetAction {}
