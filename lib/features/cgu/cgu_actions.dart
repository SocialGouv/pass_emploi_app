import 'package:pass_emploi_app/models/cgu.dart';

class CguAlreadyAcceptedAction {}

class CguNeverAcceptedAction {}

class CguUpdateRequiredAction {
  final Cgu updatedCgu;

  CguUpdateRequiredAction(this.updatedCgu);
}
