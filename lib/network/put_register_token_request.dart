import 'package:pass_emploi_app/network/json_serializable.dart';

class PutRegisterTokenRequest implements JsonSerializable {
  final String token;
  final String fuseauHoraire;

  PutRegisterTokenRequest({
    required this.token,
    required this.fuseauHoraire,
  });

  @override
  Map<String, dynamic> toJson() => {'registration_token': token, "fuseauHoraire": fuseauHoraire};
}
