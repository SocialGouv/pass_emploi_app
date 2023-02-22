import 'package:pass_emploi_app/models/diagoriente_urls.dart';

class DiagorienteUrlsRequestAction {}

class DiagorienteUrlsLoadingAction {}

class DiagorienteUrlsSuccessAction {
  final DiagorienteUrls result;

  DiagorienteUrlsSuccessAction(this.result);
}

class DiagorienteUrlsFailureAction {}

class DiagorienteUrlsResetAction {}
