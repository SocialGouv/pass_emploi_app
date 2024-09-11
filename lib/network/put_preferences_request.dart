import 'package:pass_emploi_app/network/json_serializable.dart';

class PutPreferencesRequest implements JsonSerializable {
  final bool favoris;

  PutPreferencesRequest({required this.favoris});

  @override
  Map<String, dynamic> toJson() => {"partageFavoris": favoris};
}
