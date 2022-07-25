import 'package:pass_emploi_app/network/json_serializable.dart';

class PutSharePreferencesRequest implements JsonSerializable {
  final bool favoris;

  PutSharePreferencesRequest({required this.favoris});

  @override
  Map<String, dynamic> toJson() => {"partageFavoris": favoris};
}
