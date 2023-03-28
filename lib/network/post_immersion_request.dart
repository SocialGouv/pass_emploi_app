import 'package:pass_emploi_app/models/requests/contact_immersion_request.dart';
import 'package:pass_emploi_app/network/json_serializable.dart';

class PostContactImmersionRequest implements JsonSerializable {
  final ContactImmersionRequest request;

  PostContactImmersionRequest(this.request);

  @override
  Map<String, dynamic> toJson() => {
        "codeRome": request.immersionDetails.codeRome,
        "labelRome": request.immersionDetails.metier,
        "siret": request.immersionDetails.siret,
        "prenom": request.firstName,
        "nom": request.lastName,
        "email": request.email,
        "message": request.message,
        "contactMode": "EMAIL",
      };
}
