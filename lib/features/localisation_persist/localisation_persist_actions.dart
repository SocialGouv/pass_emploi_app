import 'package:pass_emploi_app/models/location.dart';

class LocalisationPersistWriteAction {
  final Location? location;

  LocalisationPersistWriteAction(this.location);
}

class LocalisationPersistSuccessAction {
  final Location? result;

  LocalisationPersistSuccessAction(this.result);
}
