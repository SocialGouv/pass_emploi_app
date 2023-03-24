import 'package:pass_emploi_app/models/requests/contact_immersion_request.dart';

class ContactImmersionRequestAction {
  final ContactImmersionRequest request;

  ContactImmersionRequestAction(this.request);
}

class ContactImmersionLoadingAction {}

class ContactImmersionSuccessAction {}

class ContactImmersionFailureAction {}

class ContactImmersionResetAction {}
