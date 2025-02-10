import 'package:pass_emploi_app/models/remote_campagne_accueil.dart';

class RemoteCampagneAccueilSuccessAction {
  final List<RemoteCampagneAccueil> result;

  RemoteCampagneAccueilSuccessAction(this.result);
}

class RemoteCampagneAccueilDismissAction {
  final String campagneId;

  RemoteCampagneAccueilDismissAction(this.campagneId);
}
