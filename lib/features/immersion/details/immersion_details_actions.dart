import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';

class ImmersionDetailsRequestAction {
  final String immersionId;

  ImmersionDetailsRequestAction(this.immersionId);
}

class ImmersionDetailsLoadingAction {}

class ImmersionDetailsSuccessAction {
  final ImmersionDetails immersion;

  ImmersionDetailsSuccessAction(this.immersion);
}

class ImmersionDetailsIncompleteDataAction {
  final Immersion immersion;

  ImmersionDetailsIncompleteDataAction(this.immersion);
}

class ImmersionDetailsFailureAction {}
