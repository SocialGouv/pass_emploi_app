import 'package:pass_emploi_app/network/json_serializable.dart';

class PutRegisterTokenRequest implements JsonSerializable {
  final String token;

  PutRegisterTokenRequest({required this.token});

  @override
  Map<String, dynamic> toJson() => {'registration_token': token};
}
