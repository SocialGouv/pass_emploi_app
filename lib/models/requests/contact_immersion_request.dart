import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/presentation/immersion/immersion_contact_form_view_model.dart';

class ContactImmersionRequest {
  final ImmersionDetails immersionDetails;
  final ImmersionContactUserInput userInput;

  ContactImmersionRequest(this.immersionDetails, this.userInput);
}
