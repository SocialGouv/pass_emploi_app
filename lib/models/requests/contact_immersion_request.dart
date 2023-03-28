import 'package:pass_emploi_app/models/immersion_details.dart';

class ContactImmersionRequest {
  final ImmersionDetails immersionDetails;
  final String firstName;
  final String lastName;
  final String email;
  final String message;

  ContactImmersionRequest(this.immersionDetails, this.firstName, this.lastName, this.email, this.message);
}
