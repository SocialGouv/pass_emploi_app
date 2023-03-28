import 'package:pass_emploi_app/models/requests/contact_immersion_request.dart';
import 'package:pass_emploi_app/network/json_serializable.dart';

class PostContactImmersionRequest implements JsonSerializable {
  final ContactImmersionRequest request;

  PostContactImmersionRequest(this.request);
  // TODO: brancher les champs
  @override
  Map<String, dynamic> toJson() => {
        "codeRome": "",
        "labelRome": "",
        "siret": "",
        "prenom": request.firstName,
        "nom": request.lastName,
        "email": request.email,
        "contactMode": "EMAIL",
        "message": request.message,
      };
}
